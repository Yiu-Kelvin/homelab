resource "proxmox_vm_qemu" "postgres-vm" {
  name        = "postgres2"
  target_node = "ass"
  clone_id    = "8000"
  ipconfig0   = "ip=192.168.128.22/24,gw=192.168.128.1"
  pool        = "Terraform"
  ciuser      = "ubuntu"
  cipassword  = var.pm_vm_password
  sshkeys     = var.pm_ssh_public_key

  cpu {
    cores   = 4
    sockets = 1
  }
  memory = 8191
  scsihw = "virtio-scsi-pci"

  agent = 1
  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
  disks {
    ide {
      ide3 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = "32972M"
          storage = "local-lvm"
        }
      }
    }
  }
}
