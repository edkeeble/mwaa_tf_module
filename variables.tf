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
  default = "2.4.3"
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


variable "permissions_boundary_arn" {}

variable "dag_s3_path" {
  description = "(Required) The relative path to the DAG folder on your Amazon S3 storage bucket. For example, dags."
  type        = string
  default     = "dags"
}

variable "local_requirement_file_path" {
  description = "Path for requirements.txt that will be installed by default"
  type        = string
  default     = null
}

variable "local_dag_folder" {
  description = "Path to dag folder"
  type        = string
  default     = null
}

variable "mwaa_variables_json_file_id_path" {
  type = object({ file_path = string, file_id = string })

  default = {
    file_path = null
    file_id   = null
  }
}


variable "stage" {
  description = "Stage maturity (dev, sit, uat, prod...)"
}

variable "tags" {
  description = "Tags to be added to resources"
  type        = map(string)
  default     = {}
}

variable "ecs_containers" {
  type = list(object({
    handler_file_path         = string
    docker_file_path          = string
    ecs_container_folder_path = string
    ecr_repo_name             = string
  }))
  default = []
}


