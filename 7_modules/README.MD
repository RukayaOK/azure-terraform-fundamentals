# Modules

Shared modules can be reused in across your different terraform projects. 

1. Create a folder for the modules
    This folder contents is where you create your resources similar to a normal terraform project 

    Example:
    ```
    resource "azurerm_resource_group" "main" {
    name     = var.base_name
    location = var.location
    }

    variable base_name {
    type        = string
    description = "description"
    }

    variable location {
    type        = string
    description = "description"
    }

    output "id" {
        value = azurerm_resource_group.main.id
    }

    output "name" {
        value = azurerm_resource_group.main.name
    }
    ```

2. Outside of the modules folder create the terraform files for the module caller 

    ```
    module "resource_group" {
    source = "./modules/resource_group"
    base_name = "TerraformExample01"
    location = "uksouth"
    }
    ```
- Source = Path to the module. This can also be the path to extenral folders (such as a github repo containing your modules) https://www.terraform.io/language/modules/sources#github
- Pass in the variables required for this module 

3. The output of the module can also be referenced 

    Example:
    ```
    module.resource_group.name
    ```