
module "resource_group" {
  source = "./modules/resource_group"
  base_name = "terraform-rg"
  location = "uksouth"
}

module "StorageAccount" {
  source = "./modules/storage_account"
  base_name = "terraformsa"
  resource_group_name = module.resource_group.name
  location = "uksouth
}
