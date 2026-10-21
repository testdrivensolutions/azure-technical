resource "azurerm_storage_account" "application" {
  name                     = "stapp${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.platform.name
  location                 = azurerm_resource_group.platform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false
}
