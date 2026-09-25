output "s3_bucket_name" {
  description = "Nom du bucket S3 cree"
  value       = module.storage.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN du bucket S3"
  value       = module.storage.bucket_arn
}

output "dynamodb_table_name" {
  description = "Nom de la table DynamoDB creee"
  value       = module.database.table_name
}

output "dynamodb_table_arn" {
  description = "ARN de la table DynamoDB"
  value       = module.database.table_arn
}

output "resource_prefix" {
  description = "Prefixe utilise pour toutes les ressources"
  value       = local.resource_prefix
}
