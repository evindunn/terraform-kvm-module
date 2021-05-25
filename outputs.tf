output "vms" {
  value = [
    for node_idx in range(var.node_count) : {
        hostname  = "${var.network.hostname_prefix}${node_idx}", 
        ip        = "${local.network.ip_prefix}.${var.network.ip_start + node_idx}"
    }
  ]
}
