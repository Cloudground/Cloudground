provider "azurerm" {}

/* Azure resource group for terraform state of other terraform projects. */
resource "azurerm_resource_group" "state_rg" {

  name = "${var.state_resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "base"
  }
}

/* Storage account that we use to store terraform state. */
resource azurerm_storage_account "state_sa" {

  name = "${var.storage_account_name}"

  account_replication_type = "LRS"
  account_tier = "Standard"

  location = "${azurerm_resource_group.state_rg.location}"
  resource_group_name = "${azurerm_resource_group.state_rg.name}"

  tags {
    environment = "base"
  }
}