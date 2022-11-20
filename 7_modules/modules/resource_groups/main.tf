resource "azurerm_resource_group" "main" {
  name     = var.base_name
  location = var.location
}
