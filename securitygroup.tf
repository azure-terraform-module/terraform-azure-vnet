locals {
  subnets_with_public_sg = [
    for s in var.public_subnet_names : s
  ]
  subnets_with_private_sg = [
    for s in var.private_subnet_names : s
  ]

  has_public_sg  = length(local.subnets_with_public_sg) > 0
  has_private_sg = length(local.subnets_with_private_sg) > 0
}

resource "azurerm_network_security_group" "public_subnet_nsg" {
  count = local.has_public_sg ? 1 : 0

  name                = var.public_subnet_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = { for rule in var.public_subnet_nsg_rules : rule.name => rule }
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
}

resource "azurerm_network_security_group" "private_subnet_nsg" {
  count = local.has_private_sg ? 1 : 0

  name                = var.private_subnet_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = { for rule in var.private_subnet_nsg_rules : rule.name => rule }
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
}

resource "azurerm_subnet_network_security_group_association" "public_subnet_nsg" {
  for_each = { for s in var.public_subnet_names : s => s }

  subnet_id                 = azurerm_subnet.public_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.public_subnet_nsg[0].id
}

resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg" {
  for_each = { for s in var.private_subnet_names : s => s }

  subnet_id                 = azurerm_subnet.private_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.private_subnet_nsg[0].id
}