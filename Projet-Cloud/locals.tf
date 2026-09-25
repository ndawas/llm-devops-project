locals {
  # Prefixe unique utilise pour nommer toutes les ressources du projet
  resource_prefix = "${var.project_name}-${var.environment}"

  # Tags communs appliques a toutes les ressources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
