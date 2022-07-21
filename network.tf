resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "benchmark-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "benchmark-internet-gateway"
  }
}

resource "aws_eip" "lb" {
  vpc = true

  tags = {
    Name = "benchmark-elastic-ip"
  }
}

resource "aws_nat_gateway" "public_nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "benchmark-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}
