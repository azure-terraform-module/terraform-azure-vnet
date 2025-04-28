locals {
  has_nat_gateway = length(var.private_subnets) > 0
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

  name                    = var.nat_gateway_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_association" {
  for_each = local.has_nat_gateway ? azurerm_public_ip.public_ips : {}

  nat_gateway_id       = azurerm_nat_gateway.natgw[0].id
  public_ip_address_id = each.value.id
}

resource "azurerm_subnet_nat_gateway_association" "natgw_association" {
  for_each = local.has_nat_gateway ? azurerm_subnet.private_subnets : {}

  subnet_id      = each.value.id
  nat_gateway_id = azurerm_nat_gateway.natgw[0].id
}