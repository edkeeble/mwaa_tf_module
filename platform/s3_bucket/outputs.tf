output "mwaa_s3_name" {
  value = aws_s3_bucket.this.id
}

output "mwaa_s3_arn" {
  value = aws_s3_bucket.this.arn
}

output "dag_s3_path" {
  value = var.dag_s3_path
}

output "plugins_s3_path" {
  value = var.plugins_s3_path
}

output "requirements_s3_path" {
  value = aws_s3_object.reqs.key
}

output "startup_script_s3_path" {
  value = one(aws_s3_object.startup_script[*].key)
}
