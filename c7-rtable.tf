resource "azurerm_route_table" "route_table" {

  location                      = var.location
  name                          = local.route_table_name
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = merge(local.common_tags, var.tags)
}

resource "azurerm_subnet_route_table_association" "route_table" {
  for_each = { for s in local.subnet_names : s => s }

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.route_table.id
}