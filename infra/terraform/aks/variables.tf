## Azure config variables ##
variable "client_id" {}

variable "client_secret" {}

variable location {
  default = "West Europe"
}

## Resource group variables ##
variable resource_group_name {
  default = "cloudground"
}


## AKS kubernetes cluster variables ##
variable cluster_name {
  default = "cloudground"
}

variable "agent_count" {
  default = 1
}

variable "dns_prefix" {
  default = "cloudground"
}

variable "admin_username" {
    default = "demo"
}
