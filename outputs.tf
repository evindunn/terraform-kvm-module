output "vms" {
  value = [
    for node_idx in range(var.node_count) : {
        hostname  = "${var.hostname_prefix}${node_idx}", 
        mac       = "${libvirt_domain.vms[node_idx].network_interface[0].mac}"
    }
  ]
}

