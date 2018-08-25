#Terraform Azure Helloworld

## Prerequisites

* Signup for [Azure](https://azure.microsoft.com), and make sure you can login to the
  [Azure Portal](https://portal.azure.com).
* Download and install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* Tab completion should work out of the box in a new shell.
* Login on the shell using `az login`.
* Download and install HashiCorp [Terraform](https://www.terraform.io/downloads.html).

## Create the Helloworld sample

* Change to this directory
* Make sure you are correctly logged in to Azure: `az account show`
* For the first run, init terraform: `terraform init`
* Display terraform's plan: `terraform plan`
* Run the plan: `terraform apply`

## More resources

* Terraform Azure VM module: https://github.com/Azure/terraform-azurerm-vm
* Terraform configuration for provisioning a Azure Kubernetes Service (AKS) cluster: 
  https://github.com/anubhavmishra/terraform-azurerm-aks
