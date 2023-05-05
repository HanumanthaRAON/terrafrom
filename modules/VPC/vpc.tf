
locals {
  az_suffixes = slice(["a", "b", "c", "d", "e"], 0, var.az_count)
}

##VPC Creation
resource "aws_vpc" "dev_vpc" {
    cidr_block =  var.dev_vpc_cidr
    enable_dns_hostnames = true
    tags = {
      Name = "${terraform.workspace}-vpc"
      Environment = "${terraform.workspace}"
  }
  
}

### Private Subnets creation
resource "aws_subnet" "private_subs" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = "${var.aws-region}${local.az_suffixes[count.index]}"
  tags = {
    Name = "${ terraform.workspace }-PrivateSubnet-${count.index + 1}"
  }
  depends_on = [
    aws_vpc.dev_vpc,
  ]
}

### Public Subnets creation
resource "aws_subnet" "public_subs" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = "${var.aws-region}${local.az_suffixes[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = " ${ terraform.workspace }-PublicSubnet-${count.index + 1}"
  }
  depends_on = [
    aws_vpc.dev_vpc,
  ]
}

### Main Internet Gatewat Creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id
  depends_on = [
    aws_vpc.dev_vpc,
  ]

  tags = {
    name = "${ terraform.workspace }-IGW"
  }
  
}

### Public Route Table creation and attaching IGW
resource "aws_route_table" "art_public" {
  vpc_id = aws_vpc.dev_vpc.id
  depends_on = [
    aws_vpc.dev_vpc,
    aws_internet_gateway.igw,
  ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    name = "${ terraform.workspace }-Public-Route-table"
  }
  
}

resource "aws_route_table_association" "dev_rta_public" {
  depends_on = [
    aws_subnet.private_subs,
    aws_route_table.art_public,
  ]
  count             = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subs[count.index].id
  route_table_id = aws_route_table.art_public.id
}

resource "aws_eip" "dev_eip" {
  vpc = true
  tags = {
    Name = "${ terraform.workspace }-eip"
  }
}


resource "aws_nat_gateway" "dev_natgw" {
  depends_on = [
    aws_subnet.private_subs,
    aws_eip.dev_eip,
    aws_internet_gateway.igw,
  ]
  
  allocation_id = aws_eip.dev_eip.id
  subnet_id     = element(aws_subnet.public_subs.*.id,0)

  tags = {
    Name = "${ terraform.workspace }-NATGW"
  }
}

### Route Table creation for private subnet with NATGW
resource "aws_route_table" "art_private" {
  vpc_id = aws_vpc.dev_vpc.id
  depends_on = [
    aws_vpc.dev_vpc,
    aws_nat_gateway.dev_natgw,
  ]

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_natgw.id
  }

  tags = {
    name = "${ terraform.workspace }-Private-Route-table"
  }
  
}




resource "aws_route_table_association" "dev_rta_private" {
  depends_on = [
    aws_subnet.private_subs,
    aws_route_table.art_private,
  ]
  count             = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subs[count.index].id
  route_table_id = aws_route_table.art_private.id
  }



