#### VNET
variable "dns_servers" {
  type = list(string)
  default = [] # Azure default DNS
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
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    address_prefixes = list(string)
    service_endpoints = optional(list(string), [])
    delegation       = optional(object({
      name         = string
      service_name = string
      actions      = list(string)
    }))
    default_outbound_access_enabled = optional(bool, true)
    attached_public_route_table = optional(bool, false)
    attached_private_route_table = optional(bool, false)
    attached_nat_gateway = optional(bool, false)
    attached_public_security_group =  optional(bool, false)
    attached_private_security_group =  optional(bool, false)
  }))
}

variable "default_outbound_access_enabled" {
  type = string
  default = "true"
}

variable "private_endpoint_network_policies" {
  type = string
  default = "Disabled"
}

variable "private_link_service_network_policies_enabled" {
  type = string
  default = "true"
}

variable "service_endpoints" {
  description = "Optional service endpoints for subnets"
  type        = list(string)
  default     = []
}

###### NAT GW
variable "nat_gateway_name" {
  type = string
  default = null
}

variable "public_ip_names" {
  type = list(string)
  default = ["natgw-ip1"]
}

variable "zones" {
  type = list(string)
  default = ["1"]
}

variable "idle_timeout_in_minutes" {
  type = number
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
  type    = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

variable "private_routes" {
  type    = map(object({
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
  type = string
  default = null
}

variable "private_subnet_nsg_name" {
  type = string
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










# variable "ddos_protection_plan_enabled" {
#   type        = bool
#   description = "Enable or disable DDoS protection"
#   default     = false
# }

# variable "public_routes" {
#   type = map(object({
#     name                   = string
#     address_prefix         = string
#     next_hop_type          = string
#     next_hop_in_ip_address = optional(string)
#   }))
#   default     = {}
#   description = <<DESCRIPTION
#     (Optional) A map of route objects to create on the route table. 

#     - `name` - (Required) The name of the route.
#     - `address_prefix` - (Required) The destination to which the route applies. Can be CIDR (such as 10.1.0.0/16) or Azure Service Tag (such as ApiManagement, AzureBackup or AzureMonitor) format.
#     - `next_hop_type` - (Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None.
#     - `next_hop_in_ip_address` - (Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance

#     Example Input:

# ```terraform
# routes = {
#     route1 = {
#       name           = "test-route-vnetlocal"
#       address_prefix = "10.2.0.0/32"
#       next_hop_type  = "VnetLocal"
#     }
# }
# ```
# DESCRIPTION

#   validation {
#     condition     = length([for route in var.public_routes : route.name]) == length(distinct([for route in var.public_routes : route.name]))
#     error_message = "Each route name must be unique within the route table."
#   }
#   validation {
#     condition     = alltrue([for route in var.public_routes : contains(["VirtualNetworkGateway", "VnetLocal", "Internet", "VirtualAppliance", "None"], route.next_hop_type)])
#     error_message = "next_hop_type must be one of 'VirtualNetworkGateway', 'VnetLocal', 'Internet', 'VirtualAppliance' or 'None' for all routes."
#   }
#   validation {
#     condition     = alltrue([for route in var.public_routes : route.next_hop_type != "VirtualAppliance" ? route.next_hop_in_ip_address == null : true])
#     error_message = "If next_hop_type is not VirtualAppliance, next_hop_in_ip_address must be null."
#   }
# }

# variable "private_routes" {
#   type = map(object({
#     name                   = string
#     address_prefix         = string
#     next_hop_type          = string
#     next_hop_in_ip_address = optional(string)
#   }))
#   default     = {}
#   description = <<DESCRIPTION
#     (Optional) A map of route objects to create on the route table. 

#     - `name` - (Required) The name of the route.
#     - `address_prefix` - (Required) The destination to which the route applies. Can be CIDR (such as 10.1.0.0/16) or Azure Service Tag (such as ApiManagement, AzureBackup or AzureMonitor) format.
#     - `next_hop_type` - (Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None.
#     - `next_hop_in_ip_address` - (Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance

#     Example Input:

# ```terraform
# routes = {
#     route1 = {
#       name           = "test-route-vnetlocal"
#       address_prefix = "10.2.0.0/32"
#       next_hop_type  = "VnetLocal"
#     }
# }
# ```
# DESCRIPTION

#   validation {
#     condition     = length([for route in var.private_routes : route.name]) == length(distinct([for route in var.private_routes : route.name]))
#     error_message = "Each route name must be unique within the route table."
#   }
#   validation {
#     condition     = alltrue([for route in var.private_routes : contains(["VirtualNetworkGateway", "VnetLocal", "Internet", "VirtualAppliance", "None"], route.next_hop_type)])
#     error_message = "next_hop_type must be one of 'VirtualNetworkGateway', 'VnetLocal', 'Internet', 'VirtualAppliance' or 'None' for all routes."
#   }
#   validation {
#     condition     = alltrue([for route in var.private_routes : route.next_hop_type != "VirtualAppliance" ? route.next_hop_in_ip_address == null : true])
#     error_message = "If next_hop_type is not VirtualAppliance, next_hop_in_ip_address must be null."
#   }
# }