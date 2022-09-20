so, you want to be a terraform master and willing to put in the effort, great.

in this hands on guide we will cover azure then aws.

1. connect to azure using the az login.
install azure cli
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

2. terraform, install cli (azure)
https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started
<pre>
nano ~/.bashrc
alias tf='terraform'
alias tfI='terraform init'
alias tfP='terraform plan'
alias tfA='terraform apply -auto-approve'
alias tfD='terraform destroy -auto-approve'
source ~/.bashrc
</pre>

3. use the official guide !
https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started
az account set --subscription "35akss-subscription-id"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

terraform fmt
terraform validate
terraform show // show state

Store Remote State
<!-- https://learn.hashicorp.com/tutorials/terraform/azure-remote?in=terraform/azure-get-started -->
https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli

#!/bin/bash

RESOURCE_GROUP_NAME=tfstate
STORAGE_ACCOUNT_NAME=tfstate$RANDOM
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

in backend.sh - changed value STORAGE_ACCOUNT_NAME=tfstatewa$RANDOM to avoid taken error.



-- improving workflow with variables:
https://www.terraform.io/language/values/variables
