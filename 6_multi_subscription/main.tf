resource "azurerm_resource_group" "main-prod" {
  provider = azurerm.prod-sub
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "main-dev" {
  provider = azurerm.dev-sub
  name     = var.resource_group_name
  location = var.location
}
 