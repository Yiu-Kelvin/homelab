resource "oci_core_instance" "ubuntu_instance" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.tenancy_ocid
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    ocpus         = "2"
    memory_in_gbs = "16"
  }
  source_details {
    source_id   = "ocid1.image.oc1.ap-singapore-1.aaaaaaaavpms5nv7qmalnorgvemrgumiln5en2o6xmxllosxu5cdaqmgycyq"
    source_type = "image"
  }

  # Optional
  display_name = "ubuntu"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.vcn-public-subnet.id
    nsg_ids          = [oci_core_network_security_group.vm_network_security_group.id]
  }
  metadata = {
    ssh_authorized_keys = file("/home/yk/.ssh/id_ed25519.pub")
  }
  preserve_boot_volume = false

}


