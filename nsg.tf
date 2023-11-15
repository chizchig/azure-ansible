resource "azurerm_network_security_group" "cliff-nsg" {
  name                = "nsg"
  location            = azurerm_resource_group.cliff.location
  resource_group_name = azurerm_resource_group.cliff.name

  security_rule {
    name                       = "allowWinRm"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5986"] # Winrm over HTTPS
    source_address_prefix      = var.cloud_shell_source
    destination_address_prefix = "*" # Allow traffic to any destination
  }

  security_rule {
    name                       = "allowWinRm2"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5986"] # Winrm over HTTPS
    source_address_prefix      = var.cloud_shell_source
    destination_address_prefix = "*" # Allow traffic to any destination
  }

  security_rule {
    name                       = "allowWinRm3"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5986"] # Winrm over HTTPS
    source_address_prefix      = var.cloud_shell_source
    destination_address_prefix = "*" # Allow traffic to any destination
  }
}


resource "azurerm_network_interface_security_group_association" "nsg" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.mars[count.index].id
  network_security_group_id = azurerm_network_security_group.cliff-nsg.id
}
