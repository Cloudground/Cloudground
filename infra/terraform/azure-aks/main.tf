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

/* Private key for the kubernetes cluster */
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "azurerm_kubernetes_cluster" "cloudground" {
  name = "${var.cluster_name}"
  location = "${azurerm_resource_group.aks_rg.location}"
  resource_group_name = "${azurerm_resource_group.aks_rg.name}"
  dns_prefix = "${var.dns_prefix}"

  # Currently 1.9.9 is recommended by azure and automatically selected
  #kubernetes_version = "1.9.10"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = "${trimspace(tls_private_key.key.public_key_openssh)} ${var.admin_username}@azure.com"
    }
  }

  agent_pool_profile {
    name = "default"
    count = "${var.agent_count}"
    vm_size = "${var.agent_vm_size}"
    os_type = "Linux"
    os_disk_size_gb = "${var.agent_os_disk_size_gb}"
  }

  service_principal {
    /* Note: client_id refers to the application_id, not the object_id of the principal */
    client_id = "${azurerm_azuread_service_principal.aks_sp.application_id}"
    client_secret = "${azurerm_azuread_service_principal_password.aks_client_secret.value}"
  }

  # For simple ingress quick start, this addon can be enabled.
  # But according to the comments on the page below, it's really just for a quick start. :-)
  #  https://docs.microsoft.com/en-us/azure/aks/http-application-routing
  # Rather read the official documentation for ingres to find out the best way to deploy it.
  #addon_profile {
  #  http_application_routing {
  #    enabled = true
  #    http_application_routing_zone_name = "..."
  #  }
  #}

  tags {
    Environment = "aks"
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

resource "azurerm_azuread_service_principal_password" "aks_client_secret" {
  service_principal_id = "${azurerm_azuread_service_principal.aks_sp.id}"
  value = "${random_string.password.result}"
  end_date = "2020-01-01T01:00:00Z"

  # Really needed?
  # See https://www.bountysource.com/issues/61241131-azurerm_azuread_service_principal-delay-before-being-usable
  # wait 30s for server replication before attempting role assignment creation
  #provisioner "local-exec" {
  #  command = "sleep 30"
  #}
}

/* Password for service principal for kubernetes
 * Maybe we should use a keeper on the random_string resource?
 * See: https://www.terraform.io/docs/providers/random/index.html
 */
resource "random_string" "password" {
  length = 36
  special = false
}

data "azurerm_subscription" "primary" {}
