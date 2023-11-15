output "VMIps" {
  value = azurerm_public_ip.vmIps.*.ip_address
}

output "Load_Balancer_IP" {
  value = azurerm_public_ip.lbip.ip_address
}