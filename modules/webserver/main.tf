provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

resource "aws_instance" "web_server" {
  count         = length(var.private_subnets) * var.instances_per_subnet
  instance_type = var.instance_type
  ami           = var.ami_id
  subnet_id     = var.private_subnets[count.index % length(var.private_subnets)]
  
  user_data     = file("${path.module}/user_data.sh")

  vpc_security_group_ids = [aws_security_group.web_server.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web_server" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_alb" "web_server" {
  name            = var.alb_name
  subnets         = var.public_subnets
  security_groups = [aws_security_group.alb.id]
}

resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_iam_role" "web_server" {
  name = "role_iam_wbserv"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_read_only" {
  name = "RO_S3"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "web_server_policy" {
  role       = aws_iam_role.web_server.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}



output "private_ips" {
  value = aws_instance.web_server[*].private_ip
}


output "load_balancer_dns" {
  value = aws_alb.web_server.dns_name
}

output "ec2_private_ips" {
  value = aws_instance.web_server[*].private_ip
}

