# Required

variable "hostname_prefix" {
  type        = string
  description = "Prefix for the VM names"
}

variable "node_count" {
  type        = number
  description = "The number of identical VMs to create"
}

# Optional

variable "ansible_playbook" {
  type        = string
  description = "An optional playbook to run on all hosts"
  default     = null
}

variable "base_image" {
  type        = string
  description = "Cloud base image to use for the VMs"
  default     = "https://cdimage.debian.org/cdimage/cloud/buster/20211011-792/debian-10-genericcloud-amd64-20211011-792.qcow2"
}

variable "cpu_count" {
  type        = number
  description =  "The number of vcpus for each VM"
  default     = 2
}

variable "ram_size" {
  type        = number
  description = "The amount of RAM for each VM"
  default     = 2048 # 2GiB
}

variable "os_disk_size" {
  type        = number
  description = "The size of the OS disk for each VM"
  default     = 8590000000 # 8GiB
}

variable "data_volumes" {
  type        = map
  description = "Configure data volumes for each VM"

  default = {
    count = 0
    size  = 1074000000 # 1GiB
  }
}

variable "network_id" {
  description = "The libvirt_network ID for the hosts"
}

locals {
  ssh_key_pair_prefix = "terraform_${uuid()}"
  pool_name           = var.hostname_prefix
}

