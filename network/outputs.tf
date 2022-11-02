output "private_subnet_id_1" {
  value = aws_subnet.private-subnet-1.id
}

output "private_subnet_ids_2" {
  value = aws_subnet.private-subnet-2.id
}

output "private_subnet_id_3" {
  value = aws_subnet.private-subnet-3.id
}

output "vpc_id" {
  value = aws_vpc.production-vpc.id
}