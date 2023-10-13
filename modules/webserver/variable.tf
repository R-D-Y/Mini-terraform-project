variable "aws_region" {
  default = "eu-west-1"
  type    = string
}

variable "aws_profile" {
  default = "TP1"
  type    = string
}



variable "vpc_id" {
  description = "ID vpc"
  type        = string
}

variable "public_subnets" {
  type        = list(string)
}

variable "private_subnets" {
  type        = list(string)
}

variable "instances_per_subnet" {
  type        = number
}

variable "allowed_ssh_cidr" {
  type        = string
}

variable "alb_name" {
  description = "alb"
  default = "my-alb"
  type        = string
}

variable "instance_type" {
  description = "EC2"
  default     = "t2.micro"
}

variable "ami_id" {
  default = "ami-0b9fd8b55a6e3c9d5"
  type = string
}


