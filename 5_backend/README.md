# Terraform Backend

1. You can specify the backend configuration in the providers.tf 

  ```
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
  ```

  The access key for the terraform can be set as an environment variable
  ```
  export ARM_ACCESS_KEY="66e3c592-2e3c-4a3c-bd56-1412ef3f08ta"
  ```

2. Specify the backend configuration in the backend.conf

    (a) Create a backend.conf file

      ```bash
      subscription_id      = "60f16e2f-9f1c-4f4d-8f48-d36ca65d0699"
      resource_group_name  = "my-terrraform-rg"
      storage_account_name = "mystorageaccount"
      container_name       = "mycontainer"
      key                  = "terraform.tfstate"
      access_key           = "66e3c592-2e3c-4a3c-bd56-1412ef3f08ta"
      ```

    (b) In your providers.tf remove your backend configuration
      
    ```bash
    terraform {
      required_providers {
        azurerm = {
          source  = "hashicorp/azurerm"
          version = ">= 2.0.0"
        }
      }

      backend "azurerm" {}
    }

    provider "azurerm" {
      features {}
    }
    ```

    (c) Initialise terraform with the backend.conf
    ```
    terraform init --backend-config backend.conf
    ```

    (d) Remove the access key from the backend.conf
    If you don't want to speceify the access key in the backend.conf you can set it as the environment variable 
    ```
    export ARM_ACCESS_KEY="66e3c592-2e3c-4a3c-bd56-1412ef3f08ta"
    ```