resource "tls_private_key" "cluster_ssh" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "cluster_ssh_priv" {
  filename        = pathexpand("~/.ssh/${local.ssh_key_pair_prefix}")
  file_permission = "0600"
  content         = tls_private_key.cluster_ssh.private_key_pem
}

resource "local_file" "cluster_ssh_pub" {
  filename        = pathexpand("~/.ssh/${local.ssh_key_pair_prefix}.pub")
  file_permission = "0644"
  content         = tls_private_key.cluster_ssh.public_key_openssh
}

