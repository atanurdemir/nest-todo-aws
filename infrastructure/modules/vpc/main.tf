data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name        = "NestJS VPC ${var.environment}"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "Internet Gateway"
    Environment = var.environment
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name        = "Public Route Table"
    Environment = var.environment
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name        = "Private Route Table"
    Environment = var.environment
  }
}

resource "aws_main_route_table_association" "main_route_table" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidr_blocks)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = var.public_cidr_blocks[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name        = "Public Subnet ${(count.index + 1)}"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = var.private_cidr_blocks[count.index]
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name        = "Private Subnet ${(count.index + 1)}"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_eip" "nat_ip" {
  tags = {
    Name        = "NAT IP"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
}

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_cidr_blocks)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_association" {
  count          = length(var.private_cidr_blocks)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
