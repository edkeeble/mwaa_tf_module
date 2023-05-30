variable "public_subnet_cidrs" {
  type = list(string)
}
variable "tags" {
  type = map(string)
  default = {
    Author = "Abdelhak"
  }
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "vpc_cidr" {}
variable "prefix" {}