terraform {
  /* Make sure everyone uses a current version of terraform. */
  required_version = ">= 0.11.8"
}

provider "azurerm" {
  /* Avoid breaking changes by future versions of the provider */
  version = "~> 1.13"
}

/* Azure resource group base infrastructure: container registry, etc.*/
resource "azurerm_resource_group" "base_rg" {

  name = "${var.base_resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "base"
  }
}

/* Our container registry. */
resource azurerm_container_registry "base_cr" {

  name = "${var.container_registry_name}"

  resource_group_name = "${azurerm_resource_group.base_rg.name}"

  location = "${azurerm_resource_group.base_rg.location}"

  admin_enabled = false

  sku = "${var.container_registry_sku}"

  tags {
    environment = "base"
  }
}

/* Storage account for base. Not yet used. */
resource azurerm_storage_account "base_sa" {

  name = "${var.storage_account_name}"

  account_replication_type = "LRS"
  account_tier = "Standard"

  location = "${azurerm_resource_group.base_rg.location}"
  resource_group_name = "${azurerm_resource_group.base_rg.name}"

  tags {
    environment = "base"
  }
}
