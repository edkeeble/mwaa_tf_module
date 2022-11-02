data "aws_iam_policy_document" "small_sat_policies" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      var.data_bucket_arn,
      "${var.data_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
    ]
    resources = [
      var.data_table_arn,
      "${var.data_table_arn}/*"
    ]
  }

}


resource "aws_iam_policy" "read_data" {
  name        = "${var.prefix}-csda_read_data"
  path        = "/"
  description = "Read dynamo and S3"
  policy      = data.aws_iam_policy_document.small_sat_policies.json
}



