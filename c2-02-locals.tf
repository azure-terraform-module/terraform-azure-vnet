# Define Local Values in Terraform
locals {
common_tags = {
    service = "Virtual network"
    created_by = "terraform"
  }
merged_tags = merge(local.common_tags, var.tags)
}