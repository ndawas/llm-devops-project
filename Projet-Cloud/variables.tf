variable "project_name" {
  type        = string
  description = "Nom du projet"
}

variable "environment" {
  type        = string
  description = "Environnement de deploiement (dev, staging, prod)"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "L'environnement doit etre dev, staging ou prod."
  }
}

variable "aws_region" {
  type        = string
  description = "Region AWS utilisee par Floci"
  default     = "us-east-1"
}

variable "s3_versioning_enabled" {
  type        = bool
  description = "Activer le versioning S3"
  default     = true
}

variable "dynamodb_billing_mode" {
  type        = string
  description = "Mode de facturation DynamoDB (PAY_PER_REQUEST ou PROVISIONED)"
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.dynamodb_billing_mode)
    error_message = "Le mode de facturation doit etre PAY_PER_REQUEST ou PROVISIONED."
  }
}
