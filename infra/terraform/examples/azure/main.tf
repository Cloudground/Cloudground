provider "azurerm" {}

# Azure resource group for the kubernetes cluster
resource "azurerm_resource_group" "helloworld_rg" {

  name = "${var.resource_group_name}"
  location = "${var.location}"

}