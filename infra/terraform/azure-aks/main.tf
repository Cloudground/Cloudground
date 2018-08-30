terraform {
  /* Make sure everyone uses a current version of terraform. */
  required_version = ">= 0.11.8"
}

provider "azurerm" {
  /* Avoid breaking changes by future versions of the provider */
  version = "~> 1.13"
}

/* Azure resource group base infrastructure: container registry, etc.*/
resource "azurerm_resource_group" "aks_rg" {

  name = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "aks"
  }
}
