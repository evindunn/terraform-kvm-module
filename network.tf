resource "libvirt_network" "net" {
  name       = "${var.network.dns_domain}"
  mode       = "nat"
  autostart  = true
  addresses  = ["${var.network.subnet}/${var.network.prefix}"]

  dhcp {
    enabled = false
  }

  dns {
    enabled = true

    dynamic "hosts" { 
      for_each = range(var.node_count)
      iterator = idx
      content {
        hostname  = "${var.network.hostname_prefix}${idx.value}"
        ip        = "${local.network.ip_prefix}.${var.network.ip_start + idx.value}"
      }
    }
  }
}

