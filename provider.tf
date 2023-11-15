
provider "azurerm" {
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "cliff" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_availability_set" "cliff-as" {
  name                = "cliff-as"
  location            = azurerm_resource_group.cliff.location
  resource_group_name = azurerm_resource_group.cliff.name
}