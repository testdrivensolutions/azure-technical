resource "azurerm_role_assignment" "application_storage" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = azurerm_linux_web_app.application.identity[0].tenant_id
}
