variable "aws_region" {
  default = "eu-west-1"
  type    = string
}

variable "aws_profile" {
  default = "TP1"
  type    = string
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}



variable "private_subnet_ranges" {
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}


variable "public_subnet_ranges" {
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "instances_per_subnet" {
  type        = number
  default = 2
}

variable "allowed_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"  
}

