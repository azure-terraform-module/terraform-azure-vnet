# Resource-1: Create the Subnets
resource "azurerm_subnet" "subnets" {
  count                = length(var.subnets)
  name                 = "${var.vnet_name}-subnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets[count.index]]
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_assoc" {
  count          = length(azurerm_subnet.subnets)
  subnet_id      = azurerm_subnet.subnets[count.index].id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
