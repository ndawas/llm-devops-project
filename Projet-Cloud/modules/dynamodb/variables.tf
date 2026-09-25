variable "table_name" {
  type        = string
  description = "Nom de la table DynamoDB"
}

variable "billing_mode" {
  type        = string
  description = "Mode de facturation DynamoDB"
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  type        = string
  description = "Nom de l'attribut utilise comme cle de partition"
  default     = "pk"
}

variable "hash_key_type" {
  type        = string
  description = "Type de la cle de partition (S = String, N = Number, B = Binary)"
  default     = "S"
  validation {
    condition     = contains(["S", "N", "B"], var.hash_key_type)
    error_message = "Le type de cle doit etre S, N ou B."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags a appliquer sur la table"
  default     = {}
}
