#!/bin/bash
##################################################################################################
#### using azure cli to create, storage account and private container to store the terraform #####
#### state which is needed if you work with other team members or part of CI/CD as you can't #####
#### localy , Azure cli need to authenticate to your azure subscription before starting.     #####
##################################################################################################

RESOURCE_GROUP_NAME=spring-pro-infra
STORAGE_ACCOUNT_NAME=terraformstatspring
CONTAINER_NAME=state
LOCATION=eastus

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# get the access key and export it to env var or you can use it in jenkins credential for authentication.
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY