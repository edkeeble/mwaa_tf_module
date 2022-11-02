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
