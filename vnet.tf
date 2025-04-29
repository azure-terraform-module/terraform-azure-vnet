resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = merge(local.common_tags, var.tags)
}

resource "azurerm_virtual_network_dns_servers" "dns_servers" {
  virtual_network_id = azurerm_virtual_network.vnet.id
  dns_servers        = var.dns_servers
}

resource "azurerm_subnet" "subnets" {
  for_each = { for s in local.subnets_config : s.name => s }

  name                            = each.key
  address_prefixes                = each.value.address_prefixes
  service_endpoints               = each.value.service_endpoints
  virtual_network_name            = azurerm_virtual_network.vnet.name
  resource_group_name             = var.resource_group_name
  default_outbound_access_enabled = false
}