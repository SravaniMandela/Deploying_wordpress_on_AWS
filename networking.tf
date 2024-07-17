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

   resource "aws_subnet" "public" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.front_tier_cidr_block_1
    availability_zone=local.availability_zone
    map_public_ip_on_launch = true
  
    tags = {
      Name = "VPC-A-Public_tier"
    }
  }

   resource "aws_subnet" "public2" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.front_tier_cidr_block_2
    availability_zone=local.availability_zone2
    map_public_ip_on_launch = true
  
    tags = {
      Name = "VPC-A-Public_tier2"
    }
  }

 resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.app_tier_cidr_block_1
    availability_zone=local.availability_zone
  
    tags = {
      Name = "VPC-A-app-tier"
    }
  }

   resource "aws_subnet" "private2" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.app_tier_cidr_block_2
    availability_zone=local.availability_zone2
  
    tags = {
      Name = "VPC-A-app-tier2"
    }
  }

   resource "aws_subnet" "private3" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.db_tier_cidr_block_1
    availability_zone=local.availability_zone
  
    tags = {
      Name = "VPC-A-db-tier"
    }
  }

   resource "aws_subnet" "private4" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = local.db_tier_cidr_block_2
    availability_zone=local.availability_zone2
  
    tags = {
      Name = "VPC-A-db-tier2"
    }
  }

  resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id
  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  
    tags = {
      Name = "VPC-A-Public-RT"
    }
  }

    resource "aws_route_table_association" "public_tier_association" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
  }
   resource "aws_route_table_association" "public_tier_association2" {
    subnet_id      = aws_subnet.public2.id
    route_table_id = aws_route_table.public_rt.id
  }

   resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc.id
     route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.ngw.id
    }
  
    tags = {
      Name = "VPC-A-Private-RT"
    }
  }

  resource "aws_route_table" "private_rt2" {
    vpc_id = aws_vpc.vpc.id
     route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.ngw2.id
    }
  
    tags = {
      Name = "VPC-A-Private-RT2"
    }
  }


  resource "aws_route_table_association" "private_tier_association" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private_rt.id
  }

   resource "aws_route_table_association" "private_tier_association3" {
    subnet_id      = aws_subnet.private3.id
    route_table_id = aws_route_table.private_rt.id
  }

    resource "aws_route_table_association" "private_tier_association2" {
    subnet_id      = aws_subnet.private2.id
    route_table_id = aws_route_table.private_rt2.id
  }

   resource "aws_route_table_association" "private_tier_association4" {
    subnet_id      = aws_subnet.private4.id
    route_table_id = aws_route_table.private_rt2.id
  }

  resource "aws_eip" "eip" {
  domain   = "vpc"
}

 resource "aws_eip" "eip2" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "NGW"
  }
}

resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public2.id

  tags = {
    Name = "NGW2"
  }
}
