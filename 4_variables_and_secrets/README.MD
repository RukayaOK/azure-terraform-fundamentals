# Variables and Secrets


## Variables

1. Terraform native variables

Terraform can regonise the following variables and add inject them into your project where it needs them. 
```
export ARM_ACCESS_KEY="e9M2Of7bgJDXGkUjLpVQGE3nPqs5W8/Z1YBu7Jmx26+AStDU8q6w=="
export ARM_TENANT_ID="66e3c592-2e3c-4a3c-bd56-1412ef3e08ba"
export ARM_SUBSCRIPTION_ID="60f16e2f-9f1c-4f4d-8f48-d36ca65d0699"
export ARM_CLIENT_ID="4cb0066b-b5d5-4595-89b0-8b3169da6098"
export ARM_CLIENT_SECRET="Pd8Q~yGZLgnZGD4953uYhJrLWVYt_lEYUNOIaJN"
```


2. You can pass a tfvars file to your terraform commands to inject variables
    
    (a) Create a tfvars files in a prod folder
    ```
    resource_group_name="my-prod-resource-group"
    location="uksouth"
    ```

    (b) Create a tfvars files in the dev folder
    ```
    resource_group_name="my-dev-resource-group"
    location="uksouth"
    ```

    (c) Pass the variables in the terraform plan and apply commands passing in the appropriate tfvars

    Run
    ```
    terraform plan -var-file prod/config.tfvars
    ```

    Output:
    ```
    data.azuread_groups.all: Reading...
    data.azuread_groups.all: Read complete after 0s [id=groups#W5PTN0PIOJK5ZA1TqCBsLjHFefY=]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # azurerm_resource_group.main will be created
    + resource "azurerm_resource_group" "main" {
        + id       = (known after apply)
        + location = "uksouth"
        + name     = "my-resource-group"
        }

    Plan: 1 to add, 0 to change, 0 to destroy.

    Changes to Outputs:
    + existing_groups   = {
        + "aad-az-role-TechEnablement-Readers" = "a2d44463-acf0-4cfa-a50c-2d72b9cfa4fb"
        }
    + resource_group_id = (known after apply)


    Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
    ``` 

3. You can set the variables as environment variables

    Set environment variables with the prefix TF_VAR

    ```bash 
    export TF_VAR_resource_group_name=(the resource_group_name)
    export TF_VAR_location=(the location)
    ```

    You can the standard plan and apply commands 

    ```
    terraform plan
    ```

    ```
    terraform apply
    ```


## Use Cases

1. Using environment variables is useful for secrets. In this case you don't need to set the variables in the tfvars. If you do set the same variables in the tfvars, the environment variables set here will override them. 


2. You can also use this instead of ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID and ARM_TENANT_ID you can use the TF_VAR_ prefix instead. 

    ```
    export TF_VAR_client_id="4cb0066b-b5d5-4595-89b0-8b3169da6098"
    export TF_VAR_client_secret="Pd8Q~yGZLgnZGD4953uYhJrLWVYt_lEYUNOIaJN"
    export TF_VAR_subscription_id="60f16e2f-9f1c-4f4d-8f48-d36ca65d0699"
    export TF_VAR_tenant_id="66e3c592-2e3c-4a3c-bd56-1412ef3e08ba"
    ```

    In your variables.tf specify these variables
    ```
    variable "subscription_id" {
        type        = string
        description = "Subscription ID where resources will be deployed."
    }

    variable "client_id" {
        type        = string
        description = "Subscription ID where resources will be deployed."
    }

    variable "client_secret" {
        type        = string
        description = "Subscription ID where resources will be deployed."
    }

    variable "tenant_id" {
        type        = string
        description = "Subscription ID where resources will be deployed."
    }
    ```

    In your providers.tf lookup these variables
    ```
    provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    
    features {}
    }
    ```
    