terraform {
  required_version = ">=1.12.2"
  backend "oci" {
    # Required
    bucket    = "terraform-20250712-185399"
    key       = "oracle_vm"
    namespace = "axayz79dejfs"
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "my_proxmox" {
  source = "./proxmox"

  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}

module "my_oci" {
  source = "./oracle_cloud"

  private_key_path   = var.private_key_path
  fingerprint        = var.fingerprint
  user_ocid          = var.user_ocid
  namespace          = var.namespace
  docker_bucket_name = var.docker_bucket_name
  tenancy_ocid       = var.tenancy_ocid

  cloudflare_zone      = var.cloudflare_zone
  cloudflare_api_token = var.cloudflare_api_token
  providers = {
    cloudflare = cloudflare
  }
}
