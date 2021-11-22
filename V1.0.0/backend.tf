# Sets the "backend" used to store Terraform state.
# This is required to make continous delivery work.

terraform {
    backend "azurerm" {
        resource_group_name  = "spring-pro-infra"
        storage_account_name = "terraformstatspring"
        container_name       = "state"
        key                  = "terraform.tfstate"
    }
}