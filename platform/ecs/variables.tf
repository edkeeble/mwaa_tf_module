variable "prefix" {
}

variable "stage" {

  description = "Stage maturity (dev, sit, uat, prod...)"
}

variable "containers" {
  type = list(object({
    docker_image_url  = string
    container_name = string
  }))

}

variable "aws_region" {}

variable "mwaa_execution_role_arn" {}
variable "mwaa_task_role_arn" {}