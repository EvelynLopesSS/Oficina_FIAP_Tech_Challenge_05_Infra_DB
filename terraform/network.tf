resource "aws_vpc" "hackathon_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "HackathonVPC" }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.hackathon_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "HackathonPublicSubnet1" }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.hackathon_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "HackathonPublicSubnet2" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hackathon_vpc.id
  tags = { Name = "HackathonIGW" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.hackathon_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "HackathonPublicRouteTable" }
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "rds_sg" {
  name        = "hackathon-rds-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = aws_vpc.hackathon_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "HackathonRDSSecurityGroup" }
}