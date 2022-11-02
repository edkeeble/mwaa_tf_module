variable "prefix" {
  description = "Stack prefix"
}



variable "create_security_group" {
  default = false
}


variable "airflow_configuration_options" {
  description = "(Optional) The airflow_configuration_options parameter specifies airflow override options."
  type        = any
  default     = null
}


variable "airflow_version" {
  default = "2.2.2"
}
variable "environment_class" {
  default = "mw1.medium"
}
variable "max_workers" {
  default = 25
}
variable "min_workers" {
  default = 1
}
variable "schedulers" {
  description = "(Optional) The number of schedulers that you want to run in your environment."
  type        = string
  default     = null
}


variable "vpc_id" {}

variable "logging_configuration" {
  default = {
    task_logs = {
      log_level = "INFO"
    }
  }
}

variable "iam_role_additional_arn_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = map(string)
  default     = {}
}

variable "subnet_tagname" {
  default = "shared-vpc-private*"
}


variable "permissions_boundary_arn" {
  default = null
}
variable "requirements_path" {
  default = "FOOBAR"
}
