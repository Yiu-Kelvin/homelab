terraform {
  required_version = ">=1.12.2"
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


provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_tls_insecure = true # By default Proxmox Virtual Environment uses self-signed certificates.
  pm_user         = var.pm_user
  pm_password     = var.pm_password
}

