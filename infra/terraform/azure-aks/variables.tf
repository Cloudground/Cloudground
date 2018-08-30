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
