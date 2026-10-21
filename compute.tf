resource "azurerm_service_plan" "application" {
  name                = "asp-platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "application" {
  name                = "app-platform-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  service_plan_id     = azurerm_service_plan.application.id
  https_only          = true

  virtual_network_subnet_id = azurerm_subnet.application.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    minimum_tls_version = "1.2"
  }

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.application.connection_string
    STORAGE_ACCOUNT_URL                   = azurerm_storage_account.application.primary_blob_endpoint
  }
}
