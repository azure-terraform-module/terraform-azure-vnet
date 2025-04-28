locals {
  route_table_name = coalesce(var.route_table_name, "${var.vnet_name}-rtable")
  nsg_name         = coalesce(var.route_table_name, "${var.vnet_name}-nsg")
  natgw_name       = coalesce(var.nat_gateway_name, "${var.vnet_name}-natgw")

  common_tags = {
    CreatedBy = "terraform"
    VnetName  = var.vnet_name
  }
}