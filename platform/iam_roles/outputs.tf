output "execution_role_arn" {
  value = aws_iam_role.mwaa-executor.arn
}

output "lambda_s3_event_policy_arn" {
  value = aws_iam_policy.lambda_s3_event.arn

}