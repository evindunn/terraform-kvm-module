# Required

variable "node_count" {
  type        = number
  description = "The number of identical VMs to create"
}

variable "network_id" {
  type        = string
  description = "The libvirt_network ID for the hosts"
}

variable "ssh_public_key" {
  type        = string
  description = "The public key for accessing "
}

# Optional

variable "ansible_playbook" {
  type        = string
  description = "An optional string containing a playbook that will run on all hosts"
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

variable "hostname_prefix" {
  type        = string
  description = "Prefix for the VM names"
  default     = "node"
}

variable "os_disk_size" {
  type        = number
  description = "The size of the OS disk for each VM"
  default     = 8590000128 # 8GiB
}

variable "data_volumes" {
  type        = map
  description = "Configure data volumes for each VM"

  default = {
    count = 0
    size  = 1074000000 # 1GiB
  }
}

variable "mac_addresses" {
  description = "A list of mac addresses for the hosts"
  type        = list(string)
  default     = []
}

variable "extra_files" {
  description = "Extra files to write to hosts"
  default     = []
  type        = list(
    object({
      hostname    = string
      path        = string
      owner       = string
      permissions = string
      content     = string
    })
  )
}

locals {
  pool_name           = var.hostname_prefix
}

