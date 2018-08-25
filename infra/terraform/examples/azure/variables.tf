# Variables

variable resource_group_name {
  default = "helloworld-rg"
}

variable location {
  # Use "az account list-locations" to find valid location names
  default = "West Europe"
}