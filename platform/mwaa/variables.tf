variable "airflow_configuration_options" {
  description = "(Optional) The airflow_configuration_options parameter specifies airflow override options."
  type        = any
  default     = null
}

variable "mwaa_env_name" {}
variable "airflow_version" {}
variable "environment_class" {}
variable "min_workers" {}
variable "max_workers" {}
variable "kms_key" {
  description = <<-EOD
  (Optional) The Amazon Resource Name (ARN) of your KMS key that you want to use for encryption.
  Will be set to the ARN of the managed KMS key aws/airflow by default.
  EOD
  type        = string
  default     = null
}

variable "plugins_s3_object_version" {
  description = " (Optional) The plugins.zip file version you want to use."
  type        = string
  default     = null
}



variable "schedulers" {
  description = "(Optional) The number of schedulers that you want to run in your environment."
  type        = string
}

variable "webserver_access_mode" {
  description = "(Optional) Specifies whether the webserver should be accessible over the internet or via your specified VPC. Possible options: PRIVATE_ONLY (default) and PUBLIC_ONLY"
  type        = string
  default     = "PUBLIC_ONLY"

  validation {
    condition     = contains(["PRIVATE_ONLY", "PUBLIC_ONLY"], var.webserver_access_mode)
    error_message = "Invalid input, options: \"PRIVATE_ONLY\", \"PUBLIC_ONLY\"."
  }
}

variable "weekly_maintenance_window_start" {
  description = "(Optional) Specifies the start date for the weekly maintenance window"
  type        = string
  default     = null
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "logging_configuration" {
  description = "(Optional) The Apache Airflow logs which will be send to Amazon CloudWatch Logs."
  type        = any
  default     = null
}
variable "iam_role_additional_arn_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = map(string)
}
variable "prefix" {}
variable "vpc_id" {}

variable "account_id" {}
variable "lambda_s3_bucket_notification_arn" {}
