terraform {
  required_version = ">= 0.15"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.6.3"
    }
    local = {
      source = "hashicorp/local"
      version = ">= 2.1.0"
    }
  }
}

