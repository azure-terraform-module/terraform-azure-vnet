######################################
##                VNET              ##
######################################
variable "dns_servers" {
  description = "Optional list of DNS servers for the VNet. If not provided, it will default to an empty list."
  type        = list(string)
  default     = []  # This will set an empty list by default if it's not provided
  nullable     = true # Allows the variable to be optional
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default = null
}

variable "address_space" {
  description = "The address space (CIDR blocks) that is used by the virtual network."
  type        = list(string)
}

variable "location" {
  description = "The Azure region where the virtual network will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the virtual network will be created."
  type        = string
}

# variable "subnet_names" {
#   description = "List of names for the private subnets in the virtual network."
#   type        = list(string)
# }

variable "subnet_prefixes" {
  description = "List of address prefixes (CIDR blocks) for the private subnets in the virtual network."
  type        = list(string)
}


variable "nsg_rules" {
  description = "List of NSG (Network Security Group) rules for the private subnets."
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
  default     = []
}


variable "private_endpoint_network_policies" {
  description = "Controls whether private endpoint network policies are enabled for the subnet."
  type = string
  default = "Disabled"
}

variable "private_link_service_network_policies_enabled" {
  description = "Controls whether private link service network policies are enabled for the subnet."
  type = string
  default = true
}

variable "service_endpoints" {
  description = "Optional list of service endpoints for subnets in the virtual network."
  type        = list(string)
  default     = []
}

######################################
##           NAT GATEWAY            ##
######################################
variable "nat_gateway_name" {
  description = "The name of the NAT Gateway to be used for outbound internet traffic."
  type = string
  default = null
}

variable "public_ip_names" {
  description = "List of public IP names to be used by the NAT Gateway."
  type = list(string)
  default = ["natgw-ip1"]
}

variable "zones" {
  description = "List of availability zones for the NAT Gateway public IP addresses."
  type = list(string)
  default = ["1"]
}

variable "idle_timeout_in_minutes" {
  description = "Idle timeout, in minutes, for the NAT Gateway public IP addresses."
  type = number
  default = 10
}

######################################
##            ROUTE TABLE           ##
######################################
variable "route_table_name" {
  description = "The name of the route table for public subnets."
  type    = string
  default = null
}

variable "routes" {
  description = "List of public subnet route definitions, including next hop type and address."
  type    = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

variable "bgp_route_propagation_enabled" {
  description = "Enable or disable BGP route propagation for the virtual network."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to assign to resources in the virtual network."
  type        = map(string)
  default     = {}
}

######################################
##         SECURITY GROUP           ##
######################################
variable "subnet_nsg_name" {
  description = "The name of the Network Security Group for public subnets."
  type = string
  default = null
}

variable "subnet_nsg_rules" {
  description = "List of NSG rules for the public subnets."
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
  default     = []
}

######################################
##          LOCAL VARIABLE          ##
######################################
variable "environment" {
  description = "Environment identifier used as a prefix for naming resources."
  type        = string
  default     = "dev"
}

# Business Division
variable "business_division" {
  description = "The business division within the organization that this infrastructure belongs to."
  type        = string
  default     = "mdaas"
}