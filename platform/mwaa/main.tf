# ---------------------------------------------------------------------------------------------------------------------
# MWAA Environment
# ---------------------------------------------------------------------------------------------------------------------


locals {
  default_airflow_configuration_options = {
    "logging.logging_level" = "INFO"
    "webserver.dag_default_view" = "graph"
  }
  airflow_configuration_options = merge(local.default_airflow_configuration_options, var.airflow_configuration_options)
}


module "s3_bucket" {
  source = "../s3_bucket"
  bucket_name = format("%s-%s", "${var.prefix}-impact-mwaa", var.account_id)

  lambda_s3_bucket_notification_arn = var.lambda_s3_bucket_notification_arn
}


module "iam_role" {
  source = "../iam_roles"
  source_bucket_arn = module.s3_bucket.mwaa_s3_arn
  prefix = var.prefix
  mwaa_env_name = "${var.prefix}-mwaa"
  iam_role_additional_arn_policies = var.iam_role_additional_arn_policies
}



module "security_groups" {
  source = "../security_groups"
  prefix = var.prefix
  vpc_id = var.vpc_id
}



resource "aws_mwaa_environment" "mwaa" {
  name              = var.mwaa_env_name
  airflow_version   = var.airflow_version
  environment_class = var.environment_class
  min_workers       = var.min_workers
  max_workers       = var.max_workers
  kms_key           = var.kms_key

  dag_s3_path                    = module.s3_bucket.dag_s3_path
  plugins_s3_object_version      = var.plugins_s3_object_version
  plugins_s3_path                = module.s3_bucket.plugins_s3_path
  requirements_s3_path           = module.s3_bucket.requirements_s3_path
  schedulers                     = var.schedulers
  execution_role_arn             = module.iam_role.execution_role_arn
  airflow_configuration_options  = local.airflow_configuration_options

  source_bucket_arn               = module.s3_bucket.mwaa_s3_arn
  webserver_access_mode           = var.webserver_access_mode
  weekly_maintenance_window_start = var.weekly_maintenance_window_start

  tags = {
    Name = "MWAA Impact Data pipeline"
  }

  network_configuration {
    security_group_ids = module.security_groups.security_groups_ids
    subnet_ids         = var.private_subnet_ids
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = try(var.logging_configuration.dag_processing_logs.enabled, true)
      log_level = try(var.logging_configuration.dag_processing_logs.log_level, "DEBUG")
    }

    scheduler_logs {
      enabled   = try(var.logging_configuration.scheduler_logs.enabled, true)
      log_level = try(var.logging_configuration.scheduler_logs.log_level, "INFO")
    }

    task_logs {
      enabled   = try(var.logging_configuration.task_logs.enabled, true)
      log_level = try(var.logging_configuration.task_logs.log_level, "WARNING")
    }

    webserver_logs {
      enabled   = try(var.logging_configuration.webserver_logs.enabled, true)
      log_level = try(var.logging_configuration.webserver_logs.log_level, "ERROR")
    }

    worker_logs {
      enabled   = try(var.logging_configuration.worker_logs.enabled, true)
      log_level = try(var.logging_configuration.worker_logs.log_level, "CRITICAL")
    }
  }

  lifecycle {
    ignore_changes = [
      plugins_s3_object_version,
      requirements_s3_object_version
    ]
  }
}