output "airflow_url" {
  value = aws_mwaa_environment.mwaa.webserver_url
}

output "mwaa_s3_bucket_name" {
  value = module.s3_bucket.mwaa_s3_name
}

output "mwaa_s3_bucket_arn" {
  value = module.s3_bucket.mwaa_s3_arn
}
output "mwaa_environment_name" {
  value = aws_mwaa_environment.mwaa.name
}

output "requirements_s3_path" {
  value = aws_mwaa_environment.mwaa.requirements_s3_path
}

output "lambda_event_s3_policy_arn" {
  value = module.iam_role.lambda_s3_event_policy_arn
}

output "mwaa_subnet_ids" {
  value = var.private_subnet_ids
}
output "mwaa_security_group_ids" {
  value = module.security_groups.security_groups_ids
}

output "mwaa_role_arn" {
  value = module.iam_role.execution_role_arn
}

output "mwaa_arn" {
  value = aws_mwaa_environment.mwaa.arn
}