variable "aws_region" {
  default = "eu-west-1"
  type    = string
}

variable "aws_profile" {
  default = "TP1"
  type    = string
}

variable "vpc_cidr_block" {
  type        = string
}

variable "private_subnet_ranges" {
  type        = list(string)
}

variable "public_subnet_ranges" {
  type        = list(string)
}