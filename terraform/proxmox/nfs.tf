resource "proxmox_lxc" "nfs" {
  target_node     = "ass"
  hostname        = "nfs2"
  ostemplate      = "local:vztmpl/ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
  pool            = "Terraform"
  password        = var.pm_vm_password
  ssh_public_keys = var.pm_ssh_public_key
  onboot          = true
  unprivileged    = true
  start           = true

  features {
    nesting = true
  }

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }
  mountpoint {
    key    = "0"
    slot   = 0
    volume = "/main"
    mp     = "/mnt/Drive1"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.1.20/24"
    gw     = "192.168.128.1"
  }
}
