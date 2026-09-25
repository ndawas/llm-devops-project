# Configuration du provider AWS pointant vers Floci (emulateur local)
# Au lieu de communiquer avec le vrai AWS, Terraform envoie les requetes
# vers http://localhost:4566 ou Floci simule tous les services AWS.
provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
  }
}
