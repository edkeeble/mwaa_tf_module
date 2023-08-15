variable "bucket_name" {}
variable "dag_s3_path" {
  description = "(Required) The relative path to the DAG folder on your Amazon S3 storage bucket. For example, dags."
  type        = string
}

variable "plugins_s3_path" {
  description = "(Optional) The relative path to the plugins.zip file on your Amazon S3 storage bucket. For example, plugins.zip. If a relative path is provided in the request, then plugins_s3_object_version is required."
  type        = string
  default     = null
}
variable "requirements_s3_path" {
  description = "(Optional) The relative path to the requirements.txt file on your Amazon S3 storage bucket. For example, requirements.txt. If a relative path is provided in the request, then requirements_s3_object_version is required."
  type        = string
  default     = "requirements"
}

variable "requirements_filename" {
  default = "requirements.txt"
}

variable "startup_script_filename" {
  default = "startup.sh"
}

variable "lambda_s3_bucket_notification_arn" {}
# Upload requirements
variable "local_requirement_file_path" {}
variable "local_startup_script_file_path" {
  type    = string
  default = null
}


variable "local_dag_folder" {}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
}
