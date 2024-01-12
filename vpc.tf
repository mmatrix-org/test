resource "aws_vpc" "sqa-vpc" {
  cidr_block = "172.16.0.0/16"
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.sqa-vpc.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.sqa-vpc.id
  map_public_ip_on_launch = true
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "sqa-igw" {
  vpc_id = aws_vpc.sqa-vpc.id
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.sqa-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sqa-igw.id
}
