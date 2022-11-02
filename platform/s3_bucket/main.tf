locals {
  application_path = "${path.module}/../../application"
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = {
    Name = "Bucket used for WMAA"
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload DAGS
resource "aws_s3_object" "object1" {
  for_each = fileset("${local.application_path}/dags/", "*")
  bucket   = aws_s3_bucket.this.id
  key      = "${var.dag_s3_path}/${each.value}"
  source   = "${local.application_path}/dags/${each.value}"
  etag     = filemd5("${local.application_path}/dags/${each.value}")
}

# Upload plugins
resource "aws_s3_object" "plugs" {
  for_each = fileset("${local.application_path}/plugins/", "*")
  bucket   = aws_s3_bucket.this.id
  key      = "plugins/${each.value}"
  source   = "${local.application_path}/plugins/${each.value}"
  etag     = filemd5("${local.application_path}/plugins/${each.value}")
}

# Upload requirements
resource "aws_s3_object" "reqs" {
  bucket   = aws_s3_bucket.this.id
  key      = "requirements/${var.requirements_filename}"
  source   = "${local.application_path}/requirements/${var.requirements_filename}"
  etag     = filemd5("${local.application_path}/requirements/${var.requirements_filename}")
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_s3_bucket_notification_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.this.arn
}



resource "aws_s3_bucket_notification" "mwaa_bucket_notification" {
  bucket = aws_s3_bucket.this.id
  lambda_function {
    lambda_function_arn = var.lambda_s3_bucket_notification_arn
    events = ["s3:ObjectCreated:Put"]
    filter_prefix = aws_s3_object.reqs.key
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}
