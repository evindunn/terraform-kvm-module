output "private_key" {
  value = local_file.cluster_ssh_priv.filename
}

output "public_key" {
  value = local_file.cluster_ssh_pub.filename
}

output "vms" {
  value = [
    for node_idx in range(var.node_count) : {
        hostname  = "${var.hostname_prefix}${node_idx}.${var.network.dns_domain}", 
        ip        = "${local.network.ip_prefix}.${var.network.ip_start + node_idx}",
        mac       = "${libvirt_domain.vms[node_idx].network_interface[0].mac}"
    }
  ]
}

