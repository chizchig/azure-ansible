resource "azurerm_virtual_network" "main" {
  name                = "cliff-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cliff.location
  resource_group_name = azurerm_resource_group.cliff.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.cliff.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [
    azurerm_virtual_network.main
  ]
}


resource "azurerm_network_interface" "mars" {
  count               = 2
  name                = "cliff_nic-${count.index}"
  location            = azurerm_resource_group.cliff.location
  resource_group_name = azurerm_resource_group.cliff.name
  ip_configuration {
    name                          = "ip_config"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vmIps[count.index].id
  }
  depends_on = [
  azurerm_subnet.internal]
}

resource "azurerm_windows_virtual_machine" "cliffvms" {
  count               = 2
  name                = "cliffvms-${count.index}"
  admin_username      = "cadmin"
  admin_password      = "Password2021"
  computer_name       = "cliffvm-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.cliff.name
  size                = "Standard_DS1_v2"
  availability_set_id = azurerm_availability_set.cliff-as.id
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  network_interface_ids = [azurerm_network_interface.mars[count.index].id]
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [azurerm_availability_set.cliff-as]

}

resource "azurerm_virtual_machine_extension" "enablewinrm" {
  count                      = 2
  name                       = "enablewinrm"
  virtual_machine_id         = azurerm_windows_virtual_machine.cliffvms[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
  {
    "fileUris":["https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"],
    "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
  }
  SETTINGS
}
