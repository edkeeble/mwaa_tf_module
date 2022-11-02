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
}



module "lambda_s3_bucket_notification_arn" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.prefix}-mwaa-lambda"
  description   = "lambda to update MWAA"
  handler       = "lambda_src.handler"
  runtime       = "python3.9"
  publish       = true

  source_path = "./platform/lambda_event"
  role_permissions_boundary = var.permissions_boundary_arn
  timeout = 300
  store_on_s3 = true
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