output "public_ip" {
  description = "ip of the instance"
  value       = data.oci_core_vnic.ubuntu_vnic.public_ip_address
}

