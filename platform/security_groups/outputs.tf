output "security_groups_ids" {
  value = [aws_security_group.mwaa.id]
}