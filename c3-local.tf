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
  subnet_names = [
    for idx, prefix in var.subnet_prefixes : "${var.vnet_name}-subnet-${idx + 1}"
  ]
  subnets_config = [
    for idx in range(length(var.subnet_prefixes)) : {
      name              = local.subnet_names[idx]
      service_endpoints = var.service_endpoints
      address_prefixes  = [var.subnet_prefixes[idx]]
    }
  ]
}