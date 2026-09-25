# Deploiement du bucket S3 via le module storage
module "storage" {
  source = "./modules/s3"

  bucket_name        = "${local.resource_prefix}-storage"
  versioning_enabled = var.s3_versioning_enabled
  tags               = local.common_tags
}

# Deploiement de la table DynamoDB via le module database
module "database" {
  source = "./modules/dynamodb"

  table_name    = "${local.resource_prefix}-table"
  billing_mode  = var.dynamodb_billing_mode
  hash_key      = "pk"
  hash_key_type = "S"
  tags          = local.common_tags
}
