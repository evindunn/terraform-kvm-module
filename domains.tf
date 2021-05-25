locals {
  base_image_file_parts = split("/", var.base_image)
}

resource "libvirt_pool" "disk_pool" {
  name = var.pool_name
  type = "dir"
  path = "/var/lib/libvirt/images/${var.pool_name}"
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
      hostname              = "${var.network.hostname_prefix}${count.index}.${var.network.dns_domain}"
      ssh_key               = chomp(tls_private_key.cluster_ssh.public_key_openssh)
    }
  )
}

resource "libvirt_volume" "os_volumes" {
  count           = var.node_count
  base_volume_id  = libvirt_volume.base_image.id
  name            = "${var.network.hostname_prefix}${count.index}.qcow2"
  pool            = libvirt_pool.disk_pool.name
  format          = "qcow2"
  size            = var.os_disk_size
}

# resource "libvirt_volume" "data_volumes" {
#     count           = var.node_count * var.
#     name            = "${hostname_prefix}${count.index}_data.img"
#     pool            = libvirt_pool.disk_pool.name
#     format          = "raw"
#     size            = 17179869184 # 16GiB
# }

resource "libvirt_domain" "vms" {
  count           = var.node_count
  name            = "${var.network.hostname_prefix}${count.index}"
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

  network_interface {
    network_id  = libvirt_network.net.id
    hostname    = "${var.network.hostname_prefix}${count.index}"
    addresses   = ["${local.network.ip_prefix}.${var.network.ip_start + count.index}"]
  }
}

