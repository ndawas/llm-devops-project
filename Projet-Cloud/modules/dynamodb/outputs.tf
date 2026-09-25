output "table_name" {
  description = "Nom de la table DynamoDB"
  value       = aws_dynamodb_table.this.id
}

output "table_arn" {
  description = "ARN de la table DynamoDB"
  value       = aws_dynamodb_table.this.arn
}
