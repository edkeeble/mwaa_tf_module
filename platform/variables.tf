
variable "mwaa_name" {}
variable "airflow_version" {}
variable "environment_class" {}
variable "min_workers" {}
variable "max_workers" {}
variable "kms_key" {}
variable "dag_s3_path" {}
variable "plugins_s3_object_version" {}
variable "plugins_s3_path" {}
variable "requirements_s3_path" {}
variable "schedulers" {}
variable "webserver_access_mode" {}
variable "weekly_maintenance_window_start" {}
variable "private_subnet_ids" {}
variable "airflow_configuration_options" {}
variable "execution_role_arn" {}
variable "source_bucket_arn" {}
variable "data_bucket_arn" {}
variable "data_table_arn" {}

variable "security_group_ids" {
  type = list(string)
}

variable "logging_configuration" {
  description = "(Optional) The Apache Airflow logs which will be send to Amazon CloudWatch Logs."
  type        = any
  default     = null
}


variable "prefix" {}
variable "vpc_id" {}
variable "source_cidr" {}
variable "force_detach_policies" {
  type    = bool
  default = false
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = "/"
}

variable "iam_role_permissions_boundary" {
  description = "IAM role Permission boundary"
  type        = string
  default     = null
}
variable "iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = list(string)
  default     = []
}