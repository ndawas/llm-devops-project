# Tests Terraform natifs (terraform test).
# Ces tests n'utilisent que la commande "plan" : ils ne necessitent pas
# que Floci soit demarre, puisqu'aucune ressource n'est reellement creee.

variables {
  project_name          = "cloud-project"
  environment           = "dev"
  aws_region            = "us-east-1"
  s3_versioning_enabled = true
  dynamodb_billing_mode = "PAY_PER_REQUEST"
}

# Provider de secours pour le run qui teste le module dynamodb de maniere isolee
# (ce run remplace le module racine, qui perd donc providers.tf).
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# Verifie que le prefixe et les tags calcules dans locals.tf sont corrects.
run "resource_prefix_and_tags_are_correct" {
  command = plan

  assert {
    condition     = local.resource_prefix == "cloud-project-dev"
    error_message = "Le prefixe de ressource doit etre '<project_name>-<environment>'."
  }

  assert {
    condition     = local.common_tags["Project"] == "cloud-project"
    error_message = "Le tag Project doit correspondre a project_name."
  }

  assert {
    condition     = local.common_tags["Environment"] == "dev"
    error_message = "Le tag Environment doit correspondre a environment."
  }

  assert {
    condition     = local.common_tags["ManagedBy"] == "Terraform"
    error_message = "Le tag ManagedBy doit toujours valoir Terraform."
  }
}

# Verifie que la validation de la variable "environment" rejette une valeur incorrecte.
run "rejects_invalid_environment" {
  command = plan

  variables {
    environment = "invalid"
  }

  expect_failures = [
    var.environment,
  ]
}

# Verifie que la validation de la variable "dynamodb_billing_mode" rejette une valeur incorrecte.
run "rejects_invalid_billing_mode" {
  command = plan

  variables {
    dynamodb_billing_mode = "INVALID_MODE"
  }

  expect_failures = [
    var.dynamodb_billing_mode,
  ]
}

# Verifie que le prefixe change bien lorsque l'environnement change (utile pour dev/prod).
run "resource_prefix_changes_with_environment" {
  command = plan

  variables {
    environment = "prod"
  }

  assert {
    condition     = local.resource_prefix == "cloud-project-prod"
    error_message = "Le prefixe de ressource doit refleter l'environnement prod."
  }
}

# Teste directement le module dynamodb (isole du reste du projet) pour verifier
# que hash_key_type rejette une valeur en dehors de S, N, B.
run "dynamodb_module_rejects_invalid_hash_key_type" {
  command = plan

  module {
    source = "./modules/dynamodb"
  }

  providers = {
    aws = aws
  }

  variables {
    table_name    = "test-table"
    hash_key_type = "X"
  }

  expect_failures = [
    var.hash_key_type,
  ]
}
