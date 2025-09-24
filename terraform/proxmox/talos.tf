

resource "proxmox_vm_qemu" "talos-1" {
  name        = "talos-1"
  target_node = "ass"
  ipconfig0   = "ip=192.168.0.31/24,gw=192.168.128.1"
  pool        = "talos"

  cpu {
    cores   = 4
    sockets = 1
  }
  memory = 16384
  scsihw = "virtio-scsi-pci"

  agent = 1
  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
  disks {
    ide {
      ide2 {
        cdrom {
          iso = "local:iso/talos_qemu_only.iso"
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
resource "proxmox_vm_qemu" "talos-2" {
  name        = "talos-2"
  target_node = "hp1"
  ipconfig0   = "ip=192.168.0.32/24,gw=192.168.128.1"
  pool        = "talos"

  cpu {
    cores   = 4
    sockets = 1
  }
  memory = 16384
  scsihw = "virtio-scsi-pci"

  pci {
    id = 0
    pcie = true
    raw_id = "0000:00:02"
    primary_gpu = true
  }
  agent = 1
  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
  disks {
    ide {
      ide2 {
        cdrom {
          iso = "local:iso/talos_qemu_i915.iso"
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


resource "proxmox_vm_qemu" "talos-3" {
  name        = "talos-3"
  target_node = "hp2"
  ipconfig0   = "ip=192.168.0.33/24,gw=192.168.128.1"
  pool        = "talos"

  cpu {
    cores   = 4
    sockets = 1
  }
  memory = 16384
  scsihw = "virtio-scsi-pci"

  agent = 1
  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
  pci {
    id = 0
    pcie = true
    raw_id = "0000:00:02"
    primary_gpu = true
  }
  disks {
    ide {
      ide2 {
        cdrom {
          iso = "local:iso/talos_qemu_i915.iso"
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
