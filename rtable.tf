locals {
  subnets_with_public_rt = [
    for s in var.public_subnet_names : s
  ]

  subnets_with_private_rt = [
    for s in var.private_subnet_names : s
  ]

  has_public_route_table  = length(local.subnets_with_public_rt) > 0
  has_private_route_table = length(local.subnets_with_private_rt) > 0
}


# Route Tables for Public and Private
resource "azurerm_route_table" "public_route_table" {
  count = local.has_public_route_table ? 1 : 0

  location                      = var.location
  name                          = var.public_route_table_name
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

resource "azurerm_route_table" "private_route_table" {
  count = local.has_private_route_table ? 1 : 0

  location                      = var.location
  name                          = var.private_route_table_name
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

# # Routes for Public Subnet
# resource "azurerm_route" "public_routes" {
#   for_each = local.has_public_route_table ? var.public_routes : {}

#   name                   = each.value.name
#   address_prefix         = each.value.address_prefix
#   next_hop_type          = each.value.next_hop_type
#   next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
#   route_table_name       = azurerm_route_table.public_route_table[0].name
#   resource_group_name    = var.resource_group_name
# }

# # Routes for Private Subnet
# resource "azurerm_route" "private_routes" {
#   for_each = local.has_private_route_table ? var.private_routes : {}

#   name                   = each.value.name
#   address_prefix         = each.value.address_prefix
#   next_hop_type          = each.value.next_hop_type
#   next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
#   route_table_name       = azurerm_route_table.private_route_table[0].name
#   resource_group_name    = var.resource_group_name
# }


resource "azurerm_subnet_route_table_association" "public_route_table" {
  for_each = { for s in var.public_subnet_names : s => s }

  subnet_id      = azurerm_subnet.public_subnets[each.key].id
  route_table_id = azurerm_route_table.public_route_table[0].id
}

resource "azurerm_subnet_route_table_association" "private_route_table" {
  for_each = { for s in var.private_subnet_names : s => s }

  subnet_id      = azurerm_subnet.private_subnets[each.key].id
  route_table_id = azurerm_route_table.private_route_table[0].id
}