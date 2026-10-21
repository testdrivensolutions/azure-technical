resource "azurerm_log_analytics_workspace" "application" {
  name                = "law-platform-${random_string.suffix.result}"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "application" {
  name                = "appi-platform-${random_string.suffix.result}"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  workspace_id        = azurerm_log_analytics_workspace.application.id
  application_type    = "web"
}
