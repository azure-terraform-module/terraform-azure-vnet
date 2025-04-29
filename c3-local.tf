locals {
  route_table_name = "${var.vnet_name}-rtable"
  nsg_name         = "${var.vnet_name}-nsg"
  natgw_name       = "${var.vnet_name}-natgw"

  common_tags = {
    CreatedBy = "terraform"
    VnetName  = var.vnet_name
  }
}

locals {
  default_service_endpoints = ["Microsoft.Storage", "Microsoft.ContainerRegistry", "Microsoft.AzureCosmosDB", "Microsoft.ServiceBus", "Microsoft.EventHub"]
  subnet_names = [
    for idx, prefix in var.subnet_prefixes : "${var.vnet_name}-subnet-${idx + 1}"
  ]
  subnets_config = [
    for idx in range(length(var.subnet_prefixes)) : {
      name              = local.subnet_names[idx]
      service_endpoints = local.default_service_endpoints
      address_prefixes  = [var.subnet_prefixes[idx]]
    }
  ]
}

locals {
  effective_subnet_nsg_rules = length(var.subnet_nsg_rules) > 0 ? var.subnet_nsg_rules : [
    {
      name                       = "AllowAllInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowAllOutbound"
      priority                   = 200
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}