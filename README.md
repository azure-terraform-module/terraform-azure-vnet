# terraform-aws-vnet
The virtual network module 
This Terraform module helps you easily deploy a Virtual Network (VNet) along with subnets, route tables, and security groups.
The goal is to minimize user input — you just need to provide a few basic variables like the VNet name and address prefixes.

# Key Features:
Auto-generated subnet names based on the VNet name.
Auto-created Route Tables and Network Security Groups with default rules.
DNS Server configuration (optional, defaults to Azure DNS).
Tagging system: Default tags and user-defined tags are automatically merged.
Backend configured for remote state storage in Azure Blob Storage.

variables.tf file
```
######################################
##               VNET               ##
######################################
variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "mdaas-dev-vnet"
}

variable "address_space" {
  description = "The address space (CIDR blocks) used by the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "List of address prefixes (CIDR blocks) for the subnets in the virtual network."
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "dns_servers" {
  description = "Optional list of DNS servers for the virtual network. Defaults to Azure's default DNS if not provided."
  type        = list(string)
  default     = [] # Azure default DNS
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
  default = []
}


variable "service_endpoints" {
  description = "Optional list of service endpoints for subnets in the virtual network."
  type        = list(string)
  default     = ["Microsoft.Storage", "Microsoft.ContainerRegistry", "Microsoft.AzureCosmosDB", "Microsoft.ServiceBus", "Microsoft.EventHub"]
}

######################################
##             COMMON               ##
######################################
variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "westus2"
}

variable "resource_group_name" {
  description = "The name of the resource group to which the resources belong."
  type        = string
  default     = "MDaaS"
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default = {
    applied-on = "280425"
  }
}
```

provider.tf file
```
terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  backend "azurerm" {
    resource_group_name  = "example"
    storage_account_name = "example-tfstate"
    container_name       = "tfstate"
    key                  = "vnet/terraform.tfstate"
    # need access_key -> use command: terraform init -backend-config="access_key=..."
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  resource_provider_registrations = "none" # │ Attribute resource_provider_registrations value must be one of: ["none" "legacy" "core" "extended" "all"], got: "false"

  subscription_id = "<Your-Subscription-ID>" # │ Error: `subscription_id` is a required provider property when performing a plan/apply operation
}
```

vnet.tf file
```
module "vnet" {
  source = "./modules/vnet"

  vnet_name           = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  # DNS Server
  dns_servers = []

  # Subnets
  subnet_prefixes = var.subnet_prefixes

  # Service Endpoint
  service_endpoints = var.service_endpoints
  # Security Group
  subnet_nsg_rules = var.subnet_nsg_rules
  tags             = var.tags
}
```

output.tf file
```
output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = join(", ", module.vnet.vnet_address_space)
}

output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "The name of the newly created vNet"
  value       = module.vnet.vnet_name
}

output "subnet_names" {
  value = module.vnet.subnet_names
}

output "subnet_ids" {
  value = module.vnet.subnet_ids
}
```