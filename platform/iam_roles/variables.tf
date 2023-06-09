variable "prefix" {}
variable "source_bucket_arn" {}
variable "mwaa_env_name" {}
variable "force_detach_policies" {
  description = "IAM role Force detach policies"
  type        = bool
  default     = false
}
variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = "/"
}

variable "iam_role_permissions_boundary" {}

variable "iam_role_additional_arn_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = map(string)
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
}