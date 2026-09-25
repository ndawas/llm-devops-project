# Module dynamodb

Cree une table DynamoDB avec une cle de partition configurable, utilisee par le module racine pour le stockage des metadonnees.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Mode de facturation DynamoDB | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Nom de l'attribut utilise comme cle de partition | `string` | `"pk"` | no |
| <a name="input_hash_key_type"></a> [hash\_key\_type](#input\_hash\_key\_type) | Type de la cle de partition (S = String, N = Number, B = Binary) | `string` | `"S"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Nom de la table DynamoDB | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags a appliquer sur la table | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | ARN de la table DynamoDB |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | Nom de la table DynamoDB |
<!-- END_TF_DOCS -->
