resource "azurerm_public_ip" "lbip" {
  name                = "publicLbIp"
  location            = azurerm_resource_group.cliff.location
  resource_group_name = azurerm_resource_group.cliff.name
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "vmIps" {
  count               = 2
  name                = "publicVmIp-${count.index}"
  location            = azurerm_resource_group.cliff.location
  resource_group_name = azurerm_resource_group.cliff.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.domain_name_prefix}-${count.index}"
}


resource "azurerm_lb" "lb" {
  name                = "nobsloadbalancer"
  location            = azurerm_resource_group.cliff.location
  resource_group_name = azurerm_resource_group.cliff.name

  frontend_ip_configuration {
    name                 = "lb_frontend"
    public_ip_address_id = azurerm_public_ip.lbip.id
  }
}

resource "azurerm_lb_backend_address_pool" "b_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool1"
}


resource "azurerm_network_interface_backend_address_pool_association" "nic0" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.mars[count.index].id
  ip_configuration_name   = "ip_config"
  backend_address_pool_id = azurerm_lb_backend_address_pool.b_pool.id
}

resource "azurerm_lb_probe" "lbprone" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "http-running-probe"
  port                = 80
  resource_group_name = azurerm_resource_group.cliff.name
}

resource "azurerm_lb_rule" "lbrule" {
  name                           = "LBRule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lb_frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.b_pool.id]
  probe_id                       = azurerm_lb_probe.lbprone.id
  resource_group_name            = azurerm_resource_group.cliff.name
}




