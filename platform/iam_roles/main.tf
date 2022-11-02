


resource "aws_iam_role" "mwaa-executor" {
  name                  = "${var.prefix}-iam-role-executor"
  description           = "MWAA IAM Role Executor"
  assume_role_policy    = data.aws_iam_policy_document.mwaa_assume.json
  force_detach_policies = var.force_detach_policies
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary

  tags = {
    Name = "IAM role for MWAA"
  }
}

resource "aws_iam_role_policy" "mwaa" {
  name_prefix = "${var.prefix}-mwaa-executor"
  role        = aws_iam_role.mwaa-executor.id
  policy      = data.aws_iam_policy_document.mwaa.json
}


resource "aws_iam_role_policy_attachment" "mwaa" {
  for_each   = var.iam_role_additional_arn_policies
  policy_arn = each.value
  role       = aws_iam_role.mwaa-executor.id
}



resource "aws_iam_policy" "lambda_s3_event" {
  name        = "${var.prefix}-lambda-s3-event-mwaa"
  path        = "/"
  description = "Update MWAA when requirements updated"
  policy      = data.aws_iam_policy_document.lambda_s3_event_policy.json
}