output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = azurerm_subnet.subnets[*].id
}

output "name" {
  description = "The name of the virtual network to which to attach the subnet."
  value = azurerm_virtual_network.vnet.name
}