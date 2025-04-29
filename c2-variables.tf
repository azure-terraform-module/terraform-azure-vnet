######################################
##                VNET              ##
######################################
variable "dns_servers" {
  description = "Optional list of DNS servers for the VNet. If not provided, it will default to an empty list."
  type        = list(string)
  default     = []   # This will set an empty list by default if it's not provided
  nullable    = true # Allows the variable to be optional
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
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

variable "subnet_prefixes" {
  description = "List of address prefixes (CIDR blocks) for the subnets in the virtual network."
  type        = list(string)
}

variable "service_endpoints" {
  description = "Optional list of service endpoints for subnets in the virtual network. Example: [\"Microsoft.Storage\", \"Microsoft.ContainerRegistry\", \"Microsoft.AzureCosmosDB\", \"Microsoft.ServiceBus\", \"Microsoft.EventHub\"]"
  type        = list(string)
  default     = []
}

######################################
##           NAT GATEWAY            ##
######################################
variable "nat_zones" {
  description = "List of availability zones for the NAT Gateway public IP addresses."
  type        = list(string)
  default     = ["1"]
}

variable "idle_timeout_in_minutes" {
  description = "Idle timeout, in minutes, for the NAT Gateway public IP addresses."
  type        = number
  default     = 10
}

######################################
##            ROUTE TABLE           ##
######################################
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
variable "subnet_nsg_rules" {
  description = "List of NSG rules for the subnets."
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
  default = [
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