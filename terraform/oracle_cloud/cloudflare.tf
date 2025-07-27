data "oci_core_vnic_attachments" "ubuntu_vnic_attachments" {
  #Required
  compartment_id = var.tenancy_ocid

  #Optional
  instance_id = oci_core_instance.ubuntu_instance.id
}

data "oci_core_vnic" "ubuntu_vnic" {
  #Required
  vnic_id = data.oci_core_vnic_attachments.ubuntu_vnic_attachments.vnic_attachments[0].vnic_id
}

resource "cloudflare_dns_record" "tailscale_dns_record" {
  zone_id = var.cloudflare_zone
  name    = "headscale.pikaa.cc"
  type    = "A"
  comment = "Domain verification record"
  content = data.oci_core_vnic.ubuntu_vnic.public_ip_address
  ttl     = 3600
}


