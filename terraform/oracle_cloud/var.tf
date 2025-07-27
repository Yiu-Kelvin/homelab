variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-singapore-1"
}

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_zone" {
  type = string
}

variable "docker_bucket_name" {
  type = string
}

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

variable "namespace" {
  type = string
}
