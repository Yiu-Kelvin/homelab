module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.6.0"
  # insert the 1 required variable here

  # Required Inputs
  compartment_id = var.tenancy_ocid

  # Optional Inputs 
  # Changing the following default values
  vcn_name                = "terraform_vcn"
  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true
}


resource "oci_core_subnet" "vcn-public-subnet" {

  # Required
  compartment_id = var.tenancy_ocid
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.0.0/24"

  # Optional
  route_table_id = module.vcn.ig_route_id
  display_name   = "public-subnet"
}

resource "oci_core_security_list" "main_security_list" {
  compartment_id = var.tenancy_ocid
  vcn_id         = module.vcn.vcn_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "allow all egress"
  }
  ingress_security_rules {
    source   = "${chomp(data.http.my_ip.response_body)}/32"
    protocol = "all"
  }
}

resource "oci_core_network_security_group" "vm_network_security_group" {
  #Required
  compartment_id = var.tenancy_ocid
  vcn_id         = module.vcn.vcn_id
}

resource "oci_core_network_security_group_security_rule" "allow_ssh_security_group_rule" {
  network_security_group_id = oci_core_network_security_group.vm_network_security_group.id
  protocol                  = 6
  source                    = "0.0.0.0/0"
  direction                 = "INGRESS"

  description = "allow for ssh access"

  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "https_security_group_rule" {
  network_security_group_id = oci_core_network_security_group.vm_network_security_group.id
  protocol                  = 6
  source                    = "0.0.0.0/0"
  direction                 = "INGRESS"

  description = "allow for headscale access"

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}


resource "oci_core_network_security_group_security_rule" "strongswan_security_group_rule2" {
  network_security_group_id = oci_core_network_security_group.vm_network_security_group.id
  protocol                  = "all"
  source                    = "119.247.248.131/32"
  direction                 = "INGRESS"

  description = "allow for headscale grpc access"

}

resource "oci_core_network_security_group_security_rule" "http_security_group_rule" {
  network_security_group_id = oci_core_network_security_group.vm_network_security_group.id
  protocol                  = 6
  source                    = "0.0.0.0/0"
  direction                 = "INGRESS"

  description = "allow for headscale access"

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_all_egress_security_group_rule" {
  network_security_group_id = oci_core_network_security_group.vm_network_security_group.id
  protocol                  = "all"
  direction                 = "EGRESS"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

