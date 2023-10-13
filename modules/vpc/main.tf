provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_ranges)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_ranges[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_ranges)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_ranges[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

resource "aws_nat_gateway" "nat" {
  count        = 1
  subnet_id    = aws_subnet.public[0].id
  allocation_id = aws_eip.nat[0].id  
}

resource "aws_eip" "nat" {
  count = 1
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_ranges)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_ranges)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

data "aws_availability_zones" "available" {}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}


output "private_route_table_ids" {
  value = aws_route_table.private_rt.*.id
}

output "public_route_table_ids" {
  value = aws_route_table.public_rt.*.id
}


output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id
}


