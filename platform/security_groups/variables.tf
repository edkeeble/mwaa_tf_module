variable "prefix" {}
variable "vpc_id" {}

variable "source_cidr" {
  default = ["0.0.0.0/0"]
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
}