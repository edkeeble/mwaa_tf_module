output "vpc_id" {
  value = var.vpc_id # module.network.vpc_id
}

output "mwaa_s3_name" {
  value = module.mwaa.mwaa_s3_bucket_name
}

output "mwaa_s3_arn" {
  value = module.mwaa.mwaa_s3_bucket_arn
}

output "subnets" {
  value = data.aws_subnets.subnet_ids.ids
}

output "airflow_url" {
  value = module.mwaa.airflow_url
}
output "mwaa_role_arn" {
  value = module.mwaa.mwaa_role_arn
}

output "mwaa_environment_name" {
  value = module.mwaa.mwaa_environment_name
}

output "mwaa_security_groups" {
  value = module.mwaa.mwaa_security_group_ids
}

output "mwaa_module" {
  value = module.mwaa
}

output "ecs_tasks" {
  value = length(module.ecs) == 0 ? {}: module.ecs[0]
}

variable "docker_image_urls" {
  type = list(string)
  description = "List of docker images URLs"
  default = []
}