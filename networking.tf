# Creating Vpc 
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "jhc-vpc"
  }
}

# Creating  public Subnet
resource "aws_subnet" "public-subnets" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = local.azs_names[0]
  tags = {
    Name = "subnet-${local.ws}"
  }
}

# creating internetgateway and attached to the vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-${local.ws}"
  }
}

# creating routetable for public subnet
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.main.id
  # edit routes for the internetgateway 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rtb-${local.ws}"
  }
}

# edit subnet-association for the public subnet
resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public-subnets.*.id[0]
  route_table_id = aws_route_table.public-rtb.id
}