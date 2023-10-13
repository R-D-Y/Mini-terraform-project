provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  aws_region           = var.aws_region
  vpc_cidr_block       = "10.0.0.0/16"
  private_subnet_ranges = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnet_ranges  = ["10.0.2.0/24", "10.0.3.0/24"]
}

module "webserver" {
  source            = "./modules/webserver"
  aws_region        = var.aws_region
  instances_per_subnet = 2
  instance_type     = "t2.micro"
  ami_id            = "ami-0b9fd8b55a6e3c9d5"
  private_subnets   = module.vpc.private_subnet_ids
  alb_name          = "my-alb"
  vpc_id            = module.vpc.vpc_id
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  public_subnets    = module.vpc.public_subnet_ids
}

terraform {
  backend "s3" {
    profile = "TP1"
    bucket = "remi-s3-tfstate"
    key    = "tfstate/terraform.tfstate"
    region = "eu-central-1"
  }
}


output "load_balancer_dns" {
  value = module.webserver.load_balancer_dns
}



output "ec2_private_ips" {
  value = module.webserver.ec2_private_ips
}




output "vpc_id" {
  value = module.vpc.vpc_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

