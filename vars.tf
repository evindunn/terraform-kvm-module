# Required

variable "pool_name" {
  type        = string
  description = "The name of the disk pool to create"
}

variable "node_count" {
  type        = number
  description = "The number of identical VMs to create"
}

# Optional

variable "base_image" {
  type        = string
  description = "Cloud base image to use for the VMs"
  default     = "https://cdimage.debian.org/cdimage/cloud/buster/daily/20210129-530/debian-10-genericcloud-amd64-daily-20210129-530.qcow2"
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
    size  = 1049000 # 1MiB
  }
}

variable "network" {
  description = "The network configuration for the hosts"
  type        = object({
    hostname_prefix = string
    subnet          = string
    prefix          = number
    ip_start        = number
    gateway         = string
    dns_servers     = list(string)
    dns_domain      = string
  })

  default = {
    hostname_prefix = "node"
    subnet          = "192.168.110.0"
    prefix          = 24
    ip_start        = 2
    gateway         = "192.168.110.1"
    dns_servers     = ["192.168.110.1"]
    dns_domain      = "localdomain.net"
  }
}

locals {
  ssh_key_pair_prefix = "terraform_${uuid()}"
  network = {
    ip_prefix = join(".", slice(split(".", var.network.subnet), 0, 3))
  }
}

