# First Terraform Project 

---
1. Make sure the following Environment Variables are set 

    ```bash 
    export ARM_SUBSCRIPTION_ID="60f16e2f-9f1c-4f4d-8f48-d36ca65d0699"
    export ARM_TENANT_ID="66e3c592-2e3c-4a3c-bd56-1412ef3e08ba"
    export ARM_CLIENT_ID="4cb0066b-b5d5-4595-89b0-8b3169da6098"
    export ARM_CLIENT_SECRET="Pd8Q~yGZLgnZGD4953uYhJrLWVYt_lEYUNOIaJN"
    export ARM_ACCESS_KEY="66e3c592-2e3c-4a3c-bd56-1412ef3e08ba"
    ```

2. Create a file called firstterraformfile.tf with the following contents

    ```go
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
                container_name       = "<STORAGE_CONTAINER_NAME from above>"
                key                  = "terraform.tfstate"
            }

        }

        provider "azurerm" {
            features {}
        }

        resource "azurerm_resource_group" "main" {
            name     = "my-resource-group"
            location = "uksouth"
        }
    ```
3. Initialise Terraform 

    In your terminal run: 
    ```
    terraform init
    ```

    Output: 
    ```
    Initializing the backend...

    Initializing provider plugins...
    - Finding hashicorp/azurerm versions matching "~> 2.0"...
    - Installing hashicorp/azurerm v2.99.0...
    - Installed hashicorp/azurerm v2.99.0 (signed by HashiCorp)

    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```

4. Validate your Terraform 

    In your terminal run: 
    ```
    terraform validate
    ```

    Output: 
    ```
    Success! The configuration is valid.
    ```

5. Plan your Terraform run 

    In your terminal run: 
    ```
    terraform plan
    ```

    Output: 
    ```
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

    ```

6. Create your terraform resources

    In your terminal run: 
    ```
    terraform apply
    ```

    Output: 
    ```
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

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    azurerm_resource_group.main: Creating...
    azurerm_resource_group.main: Creation complete after 1s [id=/subscriptions/60f16e2f-9f1c-4f4d-8f48-d36ca65d0699/resourceGroups/my-resource-group]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    ```
    > Note: You will be prompted to confirm these actions


Your resources will now be created in Azure

7. Destroy your terraform resources

    In your terminal run: 
    ```
    terraform destroy
    ```

    Output: 
    ```
    azurerm_resource_group.main: Refreshing state... [id=/subscriptions/60f16e2f-9f1c-4f4d-8f48-d36ca65d0699/resourceGroups/my-resource-group]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    - destroy

    Terraform will perform the following actions:

    # azurerm_resource_group.main will be destroyed
    - resource "azurerm_resource_group" "main" {
        - id       = "/subscriptions/60f16e2f-9f1c-4f4d-8f48-d36ca65d0699/resourceGroups/my-resource-group" -> null
        - location = "uksouth" -> null
        - name     = "my-resource-group" -> null
        - tags     = {} -> null
        }

    Plan: 0 to add, 0 to change, 1 to destroy.

    Do you really want to destroy all resources?
    Terraform will destroy all your managed infrastructure, as shown above.
    There is no undo. Only 'yes' will be accepted to confirm.

    Enter a value: yes

    azurerm_resource_group.main: Destroying... [id=/subscriptions/60f16e2f-9f1c-4f4d-8f48-d36ca65d0699/resourceGroups/my-resource-group]
    azurerm_resource_group.main: Still destroying... [id=/subscriptions/60f16e2f-9f1c-4f4d-8f48-...d0699/resourceGroups/my-resource-group, 10s elapsed]
    azurerm_resource_group.main: Destruction complete after 15s

    Destroy complete! Resources: 1 destroyed.
    ```
    > Note: You will be prompted to confirm these actions