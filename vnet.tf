locals {
  default_service_endpoints = ["Microsoft.Storage"]
  private_subnets = [
    for idx in range(length(var.private_subnet_names)) : {
      name             = var.private_subnet_names[idx]
      service_endpoints               = local.default_service_endpoints
      address_prefixes = [var.private_subnet_prefixes[idx]]
      default_outbound_access_enabled = false
    }
  ]
  public_subnets = [
    for idx in range(length(var.public_subnet_names)) : {
      name             = var.public_subnet_names[idx]
      service_endpoints               = local.default_service_endpoints
      address_prefixes = [var.public_subnet_prefixes[idx]]
    }
  ]
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = var.tags
}

resource "azurerm_virtual_network_dns_servers" "dns_servers" {
  virtual_network_id = azurerm_virtual_network.vnet.id
  dns_servers        = var.dns_servers
}

resource "azurerm_subnet" "public_subnets" {
  for_each = { for s in local.public_subnets : s.name => s }

  name                 = each.key
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_subnet" "private_subnets" {
  for_each = { for s in local.private_subnets : s.name => s }

  name                 = each.key
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  default_outbound_access_enabled = each.value.default_outbound_access_enabled
}
