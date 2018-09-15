# Variables

variable container_registry_name {
  default = "cloudground"
}

variable base_resource_group_name {
  default = "cloudground-base"
}

variable "storage_account_name" {
  default = "cloudgroundstorage"
}

variable location {
  # Use "az account list-locations" to find valid location names
  default = "West Europe"
}

variable container_registry_sku {
  default = "Basic"
}

/* Username created for the CI/CD service to push to the ACR. */
variable ci_username {
  default = "circleci"
}
