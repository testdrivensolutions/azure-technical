# main.tf

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.62.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "platform" {
  name     = "rg-platform-interview"
  location = var.location
}

resource "azurerm_virtual_network" "platform" {
  name                = "vnet-platform"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "application" {
  name                 = "snet-application"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.30.1.0/24"]

  delegation {
    name = "app-service"

    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

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
  service_plan_id     = azurerm_service_plan.web.id
  https_only          = true

  virtual_network_subnet_id = azurerm_subnet.application.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    minimum_tls_version = "1.2"
  }

  app_settings = {
    STORAGE_ACCOUNT_URL = azurerm_storage_account.application.primary_blob_endpoint
  }
}

resource "azurerm_role_assignment" "application_storage" {
  scope                = azurerm_storage_account.application.id
  role_definition_name = "Reader"
  principal_id         = azurerm_linux_web_app.application.identity[0].principal_id
}

output "application_url" {
  value = "https://${azurerm_linux_web_app.application.default_hostname}"
}