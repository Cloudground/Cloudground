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

  lifecycle {
    prevent_destroy = true
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

/* Service principal for CI/CD pipeline service to access ACR. */
resource "azurerm_azuread_application" "acr_ci_sp_app" {
  name = "${var.ci_username}"
  homepage = "http://${var.ci_username}"
  identifier_uris = [
    "http://${var.ci_username}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "azurerm_azuread_service_principal" "acr_ci_sp" {
  application_id = "${azurerm_azuread_application.acr_ci_sp_app.application_id}"
}

resource "azurerm_azuread_service_principal_password" "acr_ci_client_secret" {
  service_principal_id = "${azurerm_azuread_service_principal.acr_ci_sp.id}"
  value = "${random_string.acr_ci_password.result}"
  end_date = "2020-01-01T01:00:00Z"
}

/* Password for service principal */
resource "random_string" "acr_ci_password" {
  length = 36
  special = false
}

resource "azurerm_role_assignment" "acr_ci_sp_role" {
  principal_id = "${azurerm_azuread_service_principal.acr_ci_sp.id}"
  # https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-service-principal
  # reader:      pull only
  # contributor: push and pull
  # owner:       push, pull, and assign roles
  role_definition_name = "Contributor"
  scope = "${azurerm_container_registry.base_cr.id}"
}

data "azurerm_client_config" "current" {}

output "ACR_SP_PASSWORD" {
  value = "${random_string.acr_ci_password.result}"
  sensitive = true
}
output "ACR_SP_APP_ID" {
  value = "${azurerm_azuread_application.acr_ci_sp_app.application_id}"
}
output "ACR_TENANT_ID" {
  value = "${data.azurerm_client_config.current.tenant_id}"
}
