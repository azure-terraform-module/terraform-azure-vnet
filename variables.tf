#### VNET
variable "dns_servers" {
  description = "List of DNS servers for the VNet"
  type        = list(string)
  default     = []   # This will set an empty list by default if it's not provided
  nullable    = true # Allows the variable to be optional
}

variable "vnet_name" {
  type        = string
  description = "The address space that is used by the virtual network"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "public_subnets" {
  description = "List of public subnets to create"
  type = list(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
  }))
}

variable "private_subnets" {
  description = "List of private subnets to create"
  type = list(object({
    name                            = string
    address_prefixes                = list(string)
    service_endpoints               = optional(list(string), [])
    default_outbound_access_enabled = optional(bool, false)
  }))
}

variable "private_endpoint_network_policies" {
  type    = string
  default = "Disabled"
}

variable "private_link_service_network_policies_enabled" {
  type    = string
  default = "true"
}

variable "service_endpoints" {
  description = "Optional service endpoints for subnets"
  type        = list(string)
  default     = []
}

###### NAT GW
variable "nat_gateway_name" {
  type    = string
  default = null
}

variable "public_ip_names" {
  type    = list(string)
  default = ["natgw-ip1"]
}

variable "zones" {
  type    = list(string)
  default = ["1"]
}

variable "idle_timeout_in_minutes" {
  type    = number
  default = 10
}

### route table
variable "public_route_table_name" {
  type    = string
  default = null
}

variable "private_route_table_name" {
  type    = string
  default = null
}

variable "public_routes" {
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

variable "private_routes" {
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

variable "bgp_route_propagation_enabled" {
  description = "Enable or disable BGP route propagation"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {}
}

## security group
variable "public_subnet_nsg_name" {
  type    = string
  default = null
}

variable "private_subnet_nsg_name" {
  type    = string
  default = null
}

variable "public_subnet_nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "List of NSG rules for public subnets"
  default     = []
}

variable "private_subnet_nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "List of NSG rules for private subnets"
  default     = []
}