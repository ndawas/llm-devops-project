# Module s3

Cree un bucket S3 avec versioning configurable, utilise par le module racine pour le stockage du projet.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Nom du bucket S3 | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags a appliquer sur le bucket | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Activer le versioning sur le bucket | `bool` | `true` | no |
## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN du bucket S3 |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Nom du bucket S3 |
<!-- END_TF_DOCS -->
