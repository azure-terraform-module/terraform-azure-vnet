locals {
  has_nat_gateway = length([
    for s in var.subnets : s if try(s.attached_nat_gateway, false)
  ]) > 0
}


resource "azurerm_public_ip" "public_ips" {
  for_each = local.has_nat_gateway ? toset(var.public_ip_names) : toset([])

  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
}

resource "azurerm_nat_gateway" "natgw" {
  count = local.has_nat_gateway ? 1 : 0

  name                = var.nat_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_association" {
  for_each = local.has_nat_gateway ? azurerm_public_ip.public_ips : {}
  
  nat_gateway_id       = azurerm_nat_gateway.natgw[0].id
  public_ip_address_id = each.value.id
}

# Attach NAT Gateway to private subnets
resource "azurerm_subnet_nat_gateway_association" "natgw_association" {
  for_each = local.has_nat_gateway ? {
    for subnet_key, subnet in var.subnets :
    subnet_key => subnet if try(subnet.attached_nat_gateway, false)
  } : {}

  subnet_id      = azurerm_subnet.subnets[each.key].id
  nat_gateway_id = azurerm_nat_gateway.natgw[0].id
}