# Variables

variable container_registry_name {
  default = "cloudground"
}

variable resource_group_name {
  default = "cloudground-aks"
}

variable location {
  # Use "az account list-locations" to find valid location names
  default = "West Europe"
}

# AKS kubernetes cluster variables #

variable cluster_name {
  default = "cloudground"
}

variable agent_count {
  default = 1
}

variable agent_vm_size {
  # Use "az vm list-sizes --location westeurope -o table" to find valid sizes
  default = "Standard_B2ms"
}

variable agent_os_disk_size_gb {
  default = 30
}

variable dns_prefix {
  default = "cloudground"
}

variable admin_username {
  default = "azureuser"
}

