resource "azurerm_role_assignment" "application_storage" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_web_app.application.identity[0].principal_id
}
