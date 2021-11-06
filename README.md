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
  node_count  = 1
}

output "vms" {
  value = module.vms.vms
}
```

# Required variables
| Name | Type | Description |
| ---- | ---- | ----------- |
| node_count | number | The number of identical vms to create | 
| network_id | string | The id of the libvirt_network to use for the vms |
                                                                                           
# Optional variables
| Name | Type | Description | Default |
| ---- | ---- | ----------- | ------- |
| ansible_playbook | string | Path to ansible playbook to run on first boot | null |
| base_image | string | Cloud base image for the VMs | [Debian generic cloud image](https://cdimage.debian.org/cdimage/cloud/buster/20211011-792/) |
| data_volumes.count | number | The number of (blank) data disks for each VM | 0 |
| data_volumes.size | number | The size of each data disk for each VM (bytes) | 1074000000 (1GiB) |
| cpu_count | number | The number of vcpus for each VM | 2 |
| hostname_prefix | string | The hostname prefix for each VM | node |
| os_disk_size | number | Size of the OS disk for each VM (bytes) | 8590000000 (8 GiB) |
| ram_size | number | The amount of RAM for each VM (MiB) | 2048 |
