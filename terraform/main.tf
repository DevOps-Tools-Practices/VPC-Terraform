provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

#################### Creating VPC ######################

resource "aws_vpc" "aws-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "example-vpc"
  }
}

#################### Creating Internet Gateway ######################

resource "aws_internet_gateway" "aws_ig" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "example-ig"
  }
}

#################### Creating Public Subnets ######################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aws-vpc.id
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = true
  count                   = length(var.public_subnets)
  tags = {
    Name = "public-subnet-${count.index + 1}"
    Tier = "public"
  }
}

#################### Creating Route table ######################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "routing-table-public"
    Tier = "public-route"
  }
}

#################### Creating Route associating ######################

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_ig.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
