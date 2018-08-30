#!/bin/bash
set -eo pipefail

cd $(dirname $0)

# Script to init terraform with azurerm backend without manually copying around the storage access key.
# Requires the currently logged in Azure user to have access to the storage account.
# Based on https://github.com/hashicorp/terraform/issues/16763#issuecomment-347022565

subscription_id=$1
[[ ${subscription_id} ]] || {
    cat >&2 <<EOF
Missing argument: subscription_id

Make sure you are logged in with 'az login'
Use one of the following subscription:
EOF
    az account list --query '[].[id, name, user.name]' --output tsv
    exit 1
}

function parse_tfvars() {
    local var=$1
    cat backend.tfvars |egrep '^'${var}'\s*=\s*"([^"]+)"\s*$' | sed -re 's/^(\w+)\s*=\s*"([^"]+)"/\2/'
}

state_storage_resource_group=$(parse_tfvars resource_group_name)
state_storage_account=$(parse_tfvars storage_account_name)
state_storage_container=$(parse_tfvars container_name)

az account set --subscription "$subscription_id"
state_storage_access_key=$(
  az storage account keys list \
    --resource-group "$state_storage_resource_group" \
    --account-name "$state_storage_account" \
    --query '[0].value' -o tsv
)

# TODO security improvement: copy values to secured temporary file instead of passing it on the command line

terraform init \
  -backend-config=backend.tfvars \
  -backend-config="access_key=$state_storage_access_key"
