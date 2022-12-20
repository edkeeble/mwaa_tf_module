terraform {
  required_providers {
    aws = {
      version = "~> 4.0"
    }
  }
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.id
  aws_region = data.aws_region.current.name
}



data "aws_subnets" "subnet_ids" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_tagname]
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "availability-zone"
    values = ["${local.aws_region}a", "${local.aws_region}b"]
  }


}


module "mwaa" {
  source                = "./platform/mwaa"
  airflow_version       = var.airflow_version
  environment_class     = var.environment_class
  max_workers           = var.max_workers
  min_workers           = var.min_workers
  mwaa_env_name         = "${var.prefix}-mwaa"
  private_subnet_ids    = data.aws_subnets.subnet_ids.ids
  schedulers            = var.schedulers
  logging_configuration = var.logging_configuration
  prefix                = var.prefix
  vpc_id                = var.vpc_id
  account_id            = local.account_id
  iam_role_additional_arn_policies = var.iam_role_additional_arn_policies
  lambda_s3_bucket_notification_arn = module.lambda_s3_bucket_notification_arn.lambda_function_arn
  dag_s3_path = var.dag_s3_path
  iam_role_permissions_boundary = var.permissions_boundary_arn
  local_dag_folder = var.local_dag_folder == null ? "${path.module}/application/dags/" : var.local_dag_folder

  local_requirement_file_path = var.local_requirement_file_path == null ? "${path.module}/application/requirements/requirements.txt" : var.local_requirement_file_path
}



resource "null_resource" "add_mwaa_vars" {
  depends_on = [module.mwaa]
  triggers = {
   mwaa_variables_json_file_id = var.mwaa_variables_json_file_id_path.file_id
 }
  provisioner "local-exec" {
   command = <<EOF
    python ${path.module}/set_mwaa_variables.py --mwaa_env_name ${module.mwaa.mwaa_environment_name} --file_path ${var.mwaa_variables_json_file_id_path.file_path}
       EOF
 }
}

module "lambda_s3_bucket_notification_arn" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = "${var.prefix}-mwaa-lambda"
  description   = "lambda to update MWAA"
  handler       = "lambda_src.handler"
  runtime       = "python3.9"
  publish       = true
  role_permissions_boundary = var.permissions_boundary_arn
  timeout = 300
  create_package         = false
  local_existing_package = "${path.module}/platform/lambda_event/lambda_src.py.zip"
  s3_bucket   = module.mwaa.mwaa_s3_bucket_name
  policy = module.mwaa.lambda_event_s3_policy_arn
  attach_policy = true

  environment_variables = {
    REQUIREMENTS_S3_PATH = module.mwaa.requirements_s3_path
    MWAA_ENV_NAME = module.mwaa.mwaa_environment_name
  }

  tags = {
    Module = "MWAA event lambda bucket"
  }
}

#moved {
#  from = module.security_groups.aws_security_group.mwaa
#  to   = module.mwaa.module.security_groups.aws_security_group.mwaa
#}