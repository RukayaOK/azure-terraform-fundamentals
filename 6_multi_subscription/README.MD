# Multi-Subscription

1. Set environment variables for you subscription IDs
   ```
    export TF_VAR_prod_subscription_id="4"
    export TF_VAR_prod_client_id=""
    export TF_VAR_prod_client_secret=""
    export TF_VAR_dev_subscription_id=""
    export TF_VAR_dev_client_id=""
    export TF_VAR_dev_client_secret=""
    ```

2. Look up the variables in your variables.tf
    ```
    variable "tenant_id" {
    type        = string
    description = "Subscription ID where resources will be deployed."
    }

    variable "prod_resource_group_name" {
    type        = string
    description = "description"
    }

    variable "prod_subscription_id" {
    type        = string
    description = "Subscription ID where resources will be deployed."
    }

    variable "prod_client_id" {
    type        = string
    description = "Subscription ID where resources will be deployed."
    }

    variable "prod_client_secret" {
    type        = string
    description = "Subscription ID where resources will be deployed."
    }

    variable "dev_resource_group_name" {
    type        = string
    description = "description"
    }

    variable "dev_subscription_id" {
    type        = string
    description = "Subscription ID where resources will be deployed."
    }

    variable "dev_client_id" {
    type        = string
    description = "Subscription ID where resources will be deployed."
    }

    variable "dev_client_secret" {
    type        = string
    description = "Subscription ID where resources will be deployed."
    }
    ```

3. Reference the variables and set an alias in the providers.tf
    ```
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
    ```

