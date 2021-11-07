# Usage

See [github.com/evindunn/terraform_k8s](https://github.com/evindunn/terraform_k8s)

```terraform
...

module "k8s_domains" {
  source            = "github.com/evindunn/terraform-kvm-module"
  hostname_prefix   = "k8s"
  ssh_public_key    = file(local_file.ssh_key_public.filename)
  node_count        = 3
  ansible_playbook  = file("./ansible-k8s-prepare.yml")
  network_id        = libvirt_network.bridge.id
  os_disk_size      = 34360000000 # 32 GiB
}

...
```

# Required variables
| Name | Type | Description |
| ---- | ---- | ----------- |
| node_count | number | The number of identical vms to create | 
| network_id | string | The id of the libvirt_network to use for the vms |
| ssh_public_key | string | The ssh public key for accessing the VMs |
                                                                                           
# Optional variables
| Name | Type | Description | Default |
| ---- | ---- | ----------- | ------- |
| ansible_playbook | string | Contents of an ansible playbook to run on first boot | null |
| base_image | string | Cloud base image for the VMs | [Debian generic cloud image](https://cdimage.debian.org/cdimage/cloud/buster/20211011-792/) |
| cpu_count | number | The number of vcpus for each VM | 2 |
| data_volumes.count | number | The number of (blank) data disks for each VM | 0 |
| data_volumes.size | number | The size of each data disk for each VM (bytes) | 1074000000 (1GiB) |
| extra_files | list | Extra files to add to cloud-init | [] |
| hostname_prefix | string | The hostname prefix for each VM | node |
| mac_addresses | list(string) | A list of mac addresses for the VMs | [] |
| os_disk_size | number | Size of the OS disk for each VM (bytes) | 8590000000 (8 GiB) |
| ram_size | number | The amount of RAM for each VM (MiB) | 2048 |
