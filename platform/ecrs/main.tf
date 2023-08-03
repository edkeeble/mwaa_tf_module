



resource "aws_ecr_repository" "ecr_image" {
  name = var.ecr_repo_name
  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}: ${var.ecr_repo_name}"
    }
  )
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_image.name
  policy = jsonencode({
    "rules" = [
      {
        "rulePriority" = 1,
        "description"  = "Expire images older than 14 days",
        "selection" : {
          "tagStatus"   = "untagged",
          "countType"   = "sinceImagePushed",
          "countUnit"   = "days",
          "countNumber" = 10
        },
        "action" : {
          "type" = "expire"
        }
      }
    ]
  })

}



resource "null_resource" "build_ecr_image" {
  triggers = {
    handler_file_path = filemd5(var.handler_file_path)
    docker_file_path  = filemd5(var.docker_file_path)
    folder_path       = sha1(join("", [for f in fileset(var.ecs_container_folder_path, "**") : filesha1("${var.ecs_container_folder_path}/${f}")]))
  }

  provisioner "local-exec" {
    command = <<EOF
          cd ${var.ecs_container_folder_path}
          aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
          docker build -t ${aws_ecr_repository.ecr_image.repository_url}:latest .
          docker push ${aws_ecr_repository.ecr_image.repository_url}:latest
          cd -
       EOF
  }
}