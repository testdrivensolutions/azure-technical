resource "azurerm_role_assignment" "application_storage" {
  scope                = azurerm_storage_account.application.id
  role_definition_name = "Reader"
  principal_id         = azurerm_linux_web_app.application.identity[0].principal_id
}
