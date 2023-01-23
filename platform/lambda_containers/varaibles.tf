variable "lambda_name" {}
variable "prefix" {}
variable "handler_file_path" {}
variable "docker_file_path" {}
variable "region" {}
variable "account_id" {}
variable "lambda_container_folder_path" {}
variable "lambda_role_arn" {}
variable "timeout" {}
variable "memory_size" {
type = number
}
variable "ephemeral_storage" {
  type = number
}