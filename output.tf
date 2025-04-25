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

output "public_subnet_names" {
  value = [
    for name, subnet in var.subnets :
    name if subnet.attached_nat_gateway == false
  ]
}

output "private_subnet_names" {
  value = [
    for name, subnet in var.subnets :
    name if subnet.attached_nat_gateway == true
  ]
}

output "private_subnet_ids" {
  description = "List of IDs for private subnets"
  value = [
    for subnet in azurerm_subnet.subnets :
    subnet.id if try(var.subnets[subnet.name].attached_nat_gateway, "") == true
  ]
}

output "public_subnet_ids" {
  description = "List of IDs for private subnets"
  value = [
    for subnet in azurerm_subnet.subnets :
    subnet.id if try(var.subnets[subnet.name].attached_nat_gateway, "") == false
  ]
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = try(azurerm_route_table.public_route_table[0].id, null)
  
}

output "private_route_table_id" {
  description = "The ID of the public route table"
  value       = try(azurerm_route_table.private_route_table[0].id, null)
}

output "public_subnet_nsg_id" {
  description = "The ID of the public subnet Network Security Group"
  value       = try(azurerm_network_security_group.public_subnet_nsg[0].id, null)
}

output "private_subnet_nsg_id" {
  description = "The ID of the public subnet Network Security Group"
  value       = try(azurerm_network_security_group.private_subnet_nsg[0].id, null)
}