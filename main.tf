resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "platform" {
  name     = "rg-platform-interview"
  location = var.location
}
