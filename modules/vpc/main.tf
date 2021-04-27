# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 0.14.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.14.x code.
  required_version = ">= 0.12.26"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${var.cluster_name}-rt"
  }
}

resource "aws_subnet" "my_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_a_cidr_block
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-sub-a"
  }
}

resource "aws_subnet" "my_subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_b_cidr_block
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-sub-b"
  }
}

resource "aws_subnet" "my_subnet_c" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_c_cidr_block
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-sub-c"
  }
}

resource "aws_route_table_association" "b" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id      = aws_subnet.my_subnet_a.id
}
resource "aws_route_table_association" "c" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id      = aws_subnet.my_subnet_b.id
}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port        = var.server_port
    to_port          = var.server_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.cluster_name}-sg"
  }
}