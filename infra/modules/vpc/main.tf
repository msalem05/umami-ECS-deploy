terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_default_security_group" "main_sg" {
  vpc_id = aws_vpc.main.id

  ingress = []
  egress  = []

  tags = {
    Name = "default-sg-deny-all"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.az)
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = false

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.az)
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.az[count.index]

}

resource "aws_eip" "eip" {
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.igw]
}

# resource "aws_nat_gateway_eip_association" "nat_eip" {
#     allocation_id = aws_eip.eip.id
#     nat_gateway_id = aws_nat_gateway.nat.id
# }

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.az)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.az)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}