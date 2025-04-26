resource "azurerm_route_table" "route_table" {
  for_each            = length(var.routes) > 0 ? { "route_table" = "route_table" } : {}
  name                = "${var.vnet_name}-route-table"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  tags = local.merged_tags
}

resource "azurerm_route" "routes" {
  for_each               = var.routes
  name                   = each.key
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table["route_table"].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}

resource "azurerm_subnet_route_table_association" "subnet_route_assoc" {
  count          = length(var.routes) > 0 ? length(azurerm_subnet.subnets) : 0
  subnet_id      = azurerm_subnet.subnets[count.index].id
  route_table_id = azurerm_route_table.route_table["route_table"].id
}