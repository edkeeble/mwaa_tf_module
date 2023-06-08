variable "prefix" {}

variable "stage" {

  description = "Stage maturity (dev, sit, uat, prod...)"
}
variable "ecr_repo_name" {}
variable "handler_file_path" {}
variable "docker_file_path" {}
variable "ecs_container_folder_path" {}
variable "account_id" {}

variable "aws_region" {}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

