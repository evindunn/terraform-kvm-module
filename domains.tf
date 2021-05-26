locals {
  base_image_file_parts = split("/", var.base_image)
}

resource "libvirt_pool" "disk_pool" {
  name = local.pool_name
  type = "dir"
  path = "/var/lib/libvirt/images/${local.pool_name}"
}

resource "libvirt_volume" "base_image" {
  name    = element(local.base_image_file_parts, length(local.base_image_file_parts) - 1)
  pool    = libvirt_pool.disk_pool.name
  source  = var.base_image
  format  = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloud_inits" {
  count           = var.node_count
  name            = "cloud_init_${count.index}.iso"
  pool            = libvirt_pool.disk_pool.name
  network_config  = templatefile(
    "${path.module}/templates/network.cfg",
    {
      ip            = "${local.network.ip_prefix}.${var.network.ip_start + count.index}"
      gateway       = "${var.network.gateway}"
      dns_servers   = var.network.dns_servers
      domain        = var.network.dns_domain
    }
  )
  user_data       = templatefile(
    "${path.module}/templates/cloud_init.cfg",
    {
      hostname              = "${var.hostname_prefix}${count.index}.${var.network.dns_domain}"
      ssh_key               = chomp(tls_private_key.cluster_ssh.public_key_openssh)
      ansible_playbook      = var.ansible_playbook
    }
  )
}

resource "libvirt_volume" "os_volumes" {
  count           = var.node_count
  base_volume_id  = libvirt_volume.base_image.id
  name            = "${var.hostname_prefix}${count.index}.qcow2"
  pool            = libvirt_pool.disk_pool.name
  format          = "qcow2"
  size            = var.os_disk_size
}

resource "libvirt_volume" "data_volumes" {
    for_each        = toset(
      flatten([
        for node_idx in range(var.node_count) : [
          for vol_idx in range(var.data_volumes.count): "${var.hostname_prefix}${node_idx}_data${vol_idx}.img"
        ]
      ])
    )
    name            = each.value
    pool            = libvirt_pool.disk_pool.name
    format          = "raw"
    size            = var.data_volumes.size
}

resource "libvirt_domain" "vms" {
  count           = var.node_count
  name            = "${var.hostname_prefix}${count.index}"
  vcpu            = var.cpu_count
  memory          = var.ram_size
  cloudinit       = libvirt_cloudinit_disk.cloud_inits[count.index].id

  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  disk {
    volume_id = libvirt_volume.os_volumes[count.index].id
    scsi      = true
  }

  dynamic "disk" {
    for_each  = toset([
      for vol_name, vol in libvirt_volume.data_volumes : 
        vol if split("_", vol.name)[0] == "${var.hostname_prefix}${count.index}"
    ])
    iterator = disk
    content {
      volume_id = disk.value.id
      scsi      = true
    }
  }

  network_interface {
    network_id  = libvirt_network.net.id
    hostname    = "${var.hostname_prefix}${count.index}"
    addresses   = ["${local.network.ip_prefix}.${var.network.ip_start + count.index}"]
  }
}

