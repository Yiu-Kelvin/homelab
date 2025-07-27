resource "oci_objectstorage_bucket" "docker_bucket" {
  #Required
  compartment_id = var.tenancy_ocid
  name           = var.docker_bucket_name
  namespace      = var.namespace
}
