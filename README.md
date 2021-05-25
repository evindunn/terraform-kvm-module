# Usage
```terraform
terraform {
  required_version = ">= 0.15"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

provider "tls" {}
provider "local" {}

module "vms" {
  source      = "/path/to/terraform-kvm-module"
  pool_name   = "test-vms"
  node_count  = 1
}

output "vms" {
  value = module.vms.vms
}
```

# Required variables
| Name | Type | Description |
| ---- | ---- | ----------- |
| pool_name | string | The name of the disk pool to create |
| node_count | number | The number of identical vms to create | 
                                                                                           
# Optional variables
| Name | Type | Description | Default |
| ---- | ---- | ----------- | ------- |
| base_image | string | Cloud base image for the VMs | [Debian generic cloud image](https://cdimage.debian.org/cdimage/cloud/buster/daily/20210129-530/debian-10-genericcloud-amd64-daily-20210129-530.qcow2) |
| cpu_count | number | The number of vcpus for each VM | 2 |
| ram_size | number | The amount of RAM for each VM (MiB) | 2048 |
| os_disk_size | number | Size of the OS disk for each VM (bytes) | 8590000000 (8 GiB) |
| network.hostname_prefix | string | The hostname prefix for each VM | node |
| network.subnet | string | The IP address for the VM subnet | 192.168.110.0 |
| network.prefix | number | The network prefix for the VM subnet | 24 |
| network.ip_start | number | Last octet (in decimal) of the first VM's IP | 2 |
| network.gateway | string | Gateway for the VM subnet | 192.168.110.1 |
| network.dns_servers | list(string) | List of dns servers for the VM subnet | ["192.168.110.1"] |
| network.dns_domain | string | Domain suffix for the subnet | localdomain.net |

