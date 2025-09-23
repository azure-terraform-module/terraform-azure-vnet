# Azure Virtual Network Terraform Module

A Terraform module to create a comprehensive Azure Virtual Network (VNet) with subnets, NAT Gateway, route tables, and network security groups.

## 🚀 Features

- **Complete VNet Setup**: Creates VNet with multiple subnets in a single deployment
- **Auto-naming**: Automatically generates subnet names based on VNet name
- **NAT Gateway**: Optional NAT Gateway for outbound internet connectivity
- **Security**: Network Security Groups with customizable rules
- **Route Tables**: Route tables with BGP propagation control
- **Service Endpoints**: Configurable service endpoints for subnets
- **Tagging**: Automatic tagging with merge support for custom tags

## 📋 Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9, < 2.0 |
| azurerm | ~> 4.0 |

## 🎯 Quick Start

```hcl
module "vnet" {
  source = "your-org/vnet/azure"
  version = "~> 1.0"

  # Required variables
  vnet_name           = "my-production-vnet"
  location            = "East US"
  resource_group_name = "my-resource-group"
  vnet_address_space  = ["10.0.0.0/16"]
  subnets             = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
```

## 📥 Inputs

### Required Variables

| Name | Description | Type |
|------|-------------|------|
| `vnet_name` | The name of the virtual network | `string` |
| `location` | The Azure region where resources will be created | `string` |
| `resource_group_name` | The name of the resource group | `string` |
| `vnet_address_space` | The address space (CIDR blocks) for the virtual network | `list(string)` |
| `subnets` | List of subnet address prefixes (CIDR blocks) | `list(string)` |

### Optional Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `enable_nat_gateway` | Enable/disable NAT Gateway creation | `bool` | `true` |
| `dns_servers` | List of DNS servers for the VNet | `list(string)` | `[]` |
| `service_endpoints` | List of service endpoints for subnets | `list(string)` | `[]` |
| `nat_zones` | Availability zones for NAT Gateway public IPs | `list(string)` | `["1"]` |
| `idle_timeout_in_minutes` | NAT Gateway idle timeout in minutes | `number` | `10` |
| `bgp_route_propagation_enabled` | Enable BGP route propagation | `bool` | `false` |
| `tags` | Tags to assign to resources | `map(string)` | `{}` |
| `subnet_nsg_rules` | Custom NSG rules for subnets | `list(object)` | Default allow-all rules |

## 📤 Outputs

| Name | Description |
|------|-------------|
| `vnet_id` | The resource ID of the virtual network |
| `vnet_name` | The name of the virtual network |
| `vnet_address_space` | The address space of the virtual network |
| `subnet_ids` | List of subnet resource IDs |
| `subnet_names` | List of subnet names |

## 💡 Usage Examples

### Basic Example

```hcl
module "basic_vnet" {
  source = "your-org/vnet/azure"
  
  vnet_name           = "basic-vnet"
  location            = "West US 2"
  resource_group_name = "example-rg"
  vnet_address_space  = ["10.0.0.0/16"]
  subnets             = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

### Advanced Example with All Features

```hcl
module "advanced_vnet" {
  source = "your-org/vnet/azure"
  
  # Required
  vnet_name           = "production-vnet"
  location            = "East US"
  resource_group_name = "production-rg"
  vnet_address_space  = ["10.0.0.0/16"]
  subnets             = [
    "10.0.1.0/24",  # subnet-1
    "10.0.2.0/24",  # subnet-2
    "10.0.3.0/24"   # subnet-3
  ]
  
  # NAT Gateway
  enable_nat_gateway        = true
  nat_zones                 = ["1", "2"]
  idle_timeout_in_minutes   = 15
  
  # DNS
  dns_servers = ["8.8.8.8", "8.8.4.4"]
  
  # Service Endpoints
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.ContainerRegistry",
    "Microsoft.AzureCosmosDB"
  ]
  
  # Routing
  bgp_route_propagation_enabled = true
  
  # Tagging
  tags = {
    Environment = "production"
    Project     = "web-app"
    Owner       = "platform-team"
  }
}
```

### Example Without NAT Gateway

```hcl
module "vnet_no_nat" {
  source = "your-org/vnet/azure"
  
  vnet_name           = "internal-vnet"
  location            = "Central US"
  resource_group_name = "internal-rg"
  vnet_address_space  = ["192.168.0.0/16"]
  subnets             = ["192.168.1.0/24", "192.168.2.0/24"]
  
  # Disable NAT Gateway for internal-only networking
  enable_nat_gateway = false
}
```

## 🏗️ What This Module Creates

- **Virtual Network** with specified address space
- **Subnets** with auto-generated names (`{vnet_name}-subnet-1`, `{vnet_name}-subnet-2`, etc.)
- **NAT Gateway** (optional) with public IP for outbound internet access
- **Route Table** associated with all subnets
- **Network Security Group** with default or custom rules
- **Service Endpoints** on subnets (if specified)

## 🎨 Naming Convention

Resources are automatically named using a consistent pattern:

| Resource | Naming Pattern | Example |
|----------|----------------|---------|
| VNet | `{vnet_name}` | `production-vnet` |
| Subnets | `{vnet_name}-subnet-{index}` | `production-vnet-subnet-1` |
| NAT Gateway | `{vnet_name}-natgw` | `production-vnet-natgw` |
| Route Table | `{vnet_name}-rtable` | `production-vnet-rtable` |
| NSG | `{vnet_name}-nsg` | `production-vnet-nsg` |

## 🔧 Provider Configuration

```hcl
terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

## 📝 License

This module is released under the MIT License. See [LICENSE](LICENSE) for details.