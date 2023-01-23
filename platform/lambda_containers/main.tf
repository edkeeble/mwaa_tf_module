data "aws_region" "current" {}

resource "aws_ecr_repository" "lambda_container" {
  name                 = var.lambda_name
  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    "name" = "${var.prefix}: ${var.lambda_name}"
  }
}



resource "null_resource" "build_ecr_image" {
 triggers = {
   handler_file_path = filemd5(var.handler_file_path)
   docker_file_path = filemd5(var.docker_file_path)
 }

 provisioner "local-exec" {
   command = <<EOF
          cd ${var.lambda_container_folder_path}
          aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.region}.amazonaws.com
          docker build -t ${aws_ecr_repository.lambda_container.repository_url}:latest .
          docker push ${aws_ecr_repository.lambda_container.repository_url}:latest
          cd -
       EOF
 }
}


data "aws_ecr_image" "lambda_container_ecr" {
 depends_on = [
   aws_ecr_repository.lambda_container,
   null_resource.build_ecr_image
 ]
 repository_name = aws_ecr_repository.lambda_container.name
  image_tag = "latest"
}



resource "aws_lambda_function" "lambda_function_container" {
  depends_on = [
   null_resource.build_ecr_image
 ]
 function_name = var.lambda_name
 role = var.lambda_role_arn
 timeout = var.timeout
 image_uri = "${aws_ecr_repository.lambda_container.repository_url}@${data.aws_ecr_image.lambda_container_ecr.id}"
 package_type = "Image"
  memory_size = var.memory_size
  ephemeral_storage {
    size = var.ephemeral_storage
  }
}