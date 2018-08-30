terraform {
  /* Make sure everyone uses a current version of terraform. */
  required_version = ">= 0.11.8"
}

provider "azurerm" {
  /* Avoid breaking changes by future versions of the provider */
  version = "~> 1.13"
}

/* Azure resource group for AKS.*/
resource "azurerm_resource_group" "aks_rg" {

  name = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "aks"
  }
}

resource "azurerm_azuread_application" "aks_sp_app" {
  name = "cloudgroundaks"
  homepage = "http://cloudgroundaks"
  identifier_uris = [
    "http://cloudgroundaks"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "azurerm_azuread_service_principal" "aks_sp" {
  application_id = "${azurerm_azuread_application.aks_sp_app.application_id}"
}

resource "azurerm_role_assignment" "aks_sp_assignment" {
  /** Scope assigned to created resource group only: */
  scope = "${azurerm_resource_group.aks_rg.id}"
  /** Alternative scope: whole subscription. */
  # scope = "${data.azurerm_subscription.primary.id}"

  role_definition_name = "Contributor"

  principal_id = "${azurerm_azuread_service_principal.aks_sp.id}"
}

data "azurerm_subscription" "primary" {}
