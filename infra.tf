provider "aws" {
    region = "us-east-1"
  }
  
  resource "aws_vpc" "vpc" {
    cidr_block       = local.vpc_cidr_block
    instance_tenancy = "default"
  
    tags = {
      Name = "VPC-main"
    }
  }
  
  resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id     
  
    tags = {
      Name = "VPC-A-IGW"
    }
  }

   resource "aws_subnet" "pub" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.front_tier_cidr_block_1
    availability_zone=local.availability_zone
    map_public_ip_on_launch = true
  
    tags = {
      Name = "VPC-A-Public"
    }
  }

   resource "aws_subnet" "pub2" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.front_tier_cidr_block_2
    availability_zone=local.availability_zone2
    map_public_ip_on_launch = true
  
    tags = {
      Name = "VPC-A-Public2"
    }
  }

 resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.app_tier_cidr_block_1
    availability_zone=local.availability_zone
  
    tags = {
      Name = "VPC-A-Private"
    }
  }

   resource "aws_subnet" "private2" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.app_tier_cidr_block_2
    availability_zone=local.availability_zone2
  
    tags = {
      Name = "VPC-A-Private2"
    }
  }

   resource "aws_subnet" "private3" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.db_tier_cidr_block_1
    availability_zone=local.availability_zone
  
    tags = {
      Name = "VPC-A-Private3"
    }
  }

   resource "aws_subnet" "private4" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.db_tier_cidr_block_2
    availability_zone=local.availability_zone2
  
    tags = {
      Name = "VPC-A-Private4"
    }
  }

  resource "aws_route_table" "rt1" {
    vpc_id = aws_vpc.vpc.id
  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  
    tags = {
      Name = "VPC-A-Public-RT"
    }
  }

    resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.pub.id
    route_table_id = aws_route_table.rt1.id
  }
   resource "aws_route_table_association" "a1" {
    subnet_id      = aws_subnet.pub2.id
    route_table_id = aws_route_table.rt1.id
  }

   resource "aws_route_table" "rt_private" {
    vpc_id = aws_vpc.vpc.id
     route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.ngw.id
    }
  
    tags = {
      Name = "VPC-A-Private-RT-2"
    }
  }

  resource "aws_route_table" "rt_private2" {
    vpc_id = aws_vpc.vpc.id
     route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.ngw2.id
    }
  
    tags = {
      Name = "VPC-A-Private-RT-New2"
    }
  }


  resource "aws_route_table_association" "a1p" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.rt_private.id
  }

   resource "aws_route_table_association" "a1p3" {
    subnet_id      = aws_subnet.private3.id
    route_table_id = aws_route_table.rt_private.id
  }

    resource "aws_route_table_association" "a1p2" {
    subnet_id      = aws_subnet.private2.id
    route_table_id = aws_route_table.rt_private2.id
  }

   resource "aws_route_table_association" "a1p4" {
    subnet_id      = aws_subnet.private4.id
    route_table_id = aws_route_table.rt_private2.id
  }

  resource "aws_eip" "eip" {
  domain   = "vpc"
}

 resource "aws_eip" "eip2" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub.id

  tags = {
    Name = "NGW"
  }
}

resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.pub2.id

  tags = {
    Name = "NGW2"
  }
}
