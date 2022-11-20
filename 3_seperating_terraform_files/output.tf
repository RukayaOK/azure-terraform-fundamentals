output "resource_group_id" {
    value = azurerm_resource_group.main.id
}

output "existing_groups" {
  value = local.existing_groups
}