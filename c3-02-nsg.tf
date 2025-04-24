# resource "azurerm_network_security_group" "subnets_nsg" {
#   name                = "${var.vnet_name}-subnets-nsg"
#   location            = var.resource_group_location
#   resource_group_name = var.resource_group_name
# }


# resource "azurerm_network_security_rule" "subnets_nsg_rule_inbound" {
#   for_each                    = var.inbound_ports_map
#   name                        = "Allow-Port-${each.value}"
#   priority                    = tonumber(each.key)
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = each.value
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.subnets_nsg.name
# }

# resource "azurerm_subnet_network_security_group_association" "subnets_nsg_assoc" {
#   depends_on = [azurerm_network_security_rule.subnets_nsg_rule_inbound]

#   count                     = length(azurerm_subnet.subnets)
#   subnet_id                 = azurerm_subnet.subnets[count.index].id
#   network_security_group_id = azurerm_network_security_group.subnets_nsg.id
# }