resource "proxmox_vm_qemu" "netbox-vm" {
  name        = "netbox"
  target_node = "ass"
  clone_id    = "8000"
  ipconfig1   = "ip=192.168.168.25,gw=192.168.128.1"
  cpu {
    cores   = 4
    sockets = 1
  }
  memory = 8192
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
