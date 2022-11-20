terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "fgterstorageaccount"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  alias           = "prod-sub"
  subscription_id = var.prod_subscription_id
  client_id       = var.prod_client_id
  client_secret   = var.prod_client_secret
  tenant_id       = var.tenant_id

  features {}
}

provider "azurerm" {
  alias           = "dev-sub"
  subscription_id = var.dev_subscription_id
  client_id       = var.dev_client_id
  client_secret   = var.dev_client_secret
  tenant_id       = var.tenant_id

  features {}
}