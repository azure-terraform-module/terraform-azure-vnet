resource "azurerm_network_security_group" "subnet_nsg" {
  # count = var.subnet_nsg_name != null ? 1 : 0

  name                = local.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = { for rule in var.subnet_nsg_rules : rule.name => rule }
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
  tags = merge(local.common_tags, var.tags)
}

# resource "azurerm_network_security_group" "private_subnet_nsg" {
#   count = local.has_private_sg ? 1 : 0

#   name                = var.private_subnet_nsg_name
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   dynamic "security_rule" {
#     for_each = { for rule in var.private_subnet_nsg_rules : rule.name => rule }
#     content {
#       name                       = security_rule.value.name
#       priority                   = security_rule.value.priority
#       direction                  = security_rule.value.direction
#       access                     = security_rule.value.access
#       protocol                   = security_rule.value.protocol
#       source_port_range          = security_rule.value.source_port_range
#       destination_port_range     = security_rule.value.destination_port_range
#       source_address_prefix      = security_rule.value.source_address_prefix
#       destination_address_prefix = security_rule.value.destination_address_prefix
#     }
#   }
# }

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each = { for s in local.subnet_names : s => s }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.subnet_nsg.id
}

# resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg" {
#   for_each = { for s in var.private_subnet_names : s => s }

#   subnet_id                 = azurerm_subnet.private_subnets[each.key].id
#   network_security_group_id = azurerm_network_security_group.private_subnet_nsg[0].id
# }