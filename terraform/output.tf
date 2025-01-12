output "vpc" {
  value = aws_vpc.aws-vpc.arn
}

output "public_subnets" {
  value = aws_subnet.public[*].arn
}

output "internet_gateway" {
  value = aws_internet_gateway.aws_ig.arn
}
