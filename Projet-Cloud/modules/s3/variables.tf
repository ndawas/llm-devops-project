variable "bucket_name" {
  type        = string
  description = "Nom du bucket S3"
}

variable "versioning_enabled" {
  type        = bool
  description = "Activer le versioning sur le bucket"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags a appliquer sur le bucket"
  default     = {}
}
