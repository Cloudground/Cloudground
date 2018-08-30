# Variables

variable state_resource_group_name {
  default = "cloudground-state"
}

variable storage_account_name {
  default = "cloudgroundtfstate"
}

variable location {
  # Use "az account list-locations" to find valid location names
  default = "West Europe"
}