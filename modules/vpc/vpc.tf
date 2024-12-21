resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.vpc_az)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.vpc_az, count.index)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.vpc_az)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public.id
}



output "id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "route_table_id" {
  value = aws_route_table.public
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}