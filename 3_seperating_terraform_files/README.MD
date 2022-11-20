# Seperating out terraform files 

## providers.tf
Stores the different providers you are using in your terraform project. 

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

provider "azurerm" {
  features {}
}
```

## variables.tf 
The list of variables to be passed into your main.tf

```bash
variable resource_group_name {
  type        = string
  description = "description"
}

variable location {
  type        = string
  description = "description"
  default     = "uksouth"
}
```

## main.tf
The terraform code for creating your resources. This file can also be named something else for instance resource_groups.tf might store all your resource groups. 

```bash
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}
```

## locals.tf
You may way to do some manipulation of input variables. For example:

```go
locals {
    
  existing_groups = zipmap(
                            data.azuread_groups.all.display_names
                            , data.azuread_groups.all.object_ids
                          )
  
}
```
## data.tf

```go
data "azuread_groups" "all" {
  return_all = true
}
```

## output.tf
This contains the outputs of your terraform files. The example below 

```bash
output "resource_group_id" {
    value = azurerm_resource_group.main.id
}

output "existing_groups" {
  value = local.existing_groups
}
```

## configuration.tfvars

```
resource_group_name="my-resource-group"
location="uksouth"
```

Pass the variables in the terraform plan and apply commands

Run
```
terraform plan -var-file config.tfvars
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