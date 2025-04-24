output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = azurerm_subnet.subnets[*].id
}