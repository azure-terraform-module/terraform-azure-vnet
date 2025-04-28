output "vnet_name" {
  description = "The resource name of the virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "The Azure Virtual Network resource.  This will be null if an existing vnet is supplied."
  value       = tolist(azurerm_virtual_network.vnet.address_space)
}

output "vnet_id" {
  description = "The resource ID of the virtual network."
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_names" {
  description = "List of private subnet names"
  value       = [for s in azurerm_subnet.subnets : s.name]
}

output "subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in azurerm_subnet.subnets : s.id]
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = try(azurerm_route_table.route_table.id, null)

}

output "subnet_nsg_id" {
  description = "The ID of the public subnet Network Security Group"
  value       = try(azurerm_network_security_group.subnet_nsg.id, null)
}