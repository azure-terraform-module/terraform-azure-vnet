# Azure Resource Group Name 
variable "resource_group_name" {
  description = "Resource Group Name"
  type = string
  default = "Nimtechnology"  
}

# Azure Resources Location
variable "resource_group_location" {
  description = "Region in which Azure Resources to be created"
  type = string
  default = "westus2"  
}

variable "vnet_name" {
  description = "Virtual Network name"
  type = string
  default = "vnet-default"
}

variable "vnet_address_space" {
  description = "Virtual Network address_space"
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "inbound_ports_map" {
  description = "Map of inbound ports and their priorities for NSG rules"
  type        = map(string)
  default = {
    "100" = "80"
    "110" = "443"
    "120" = "22"
  }
}

variable "routes" {
  description = "Map of routes with address prefixes and next hop IP addresses"
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {
    "route1" = {
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "Internet"
      next_hop_in_ip_address = null
    }
  }
}