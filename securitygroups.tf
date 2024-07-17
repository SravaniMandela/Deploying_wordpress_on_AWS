 resource "aws_security_group" "webserver_sg" {
  
    vpc_id = aws_vpc.vpc.id
  
ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [local.front_tier_cidr_block_1,local.front_tier_cidr_block_2]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.front_tier_cidr_block_1,local.front_tier_cidr_block_2]
  }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
      Name = "webserver-sg"
    }
  }

  resource "aws_security_group" "db_sg" {
  
    vpc_id = aws_vpc.vpc.id
  
    ingress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [local.app_tier_cidr_block_1,local.app_tier_cidr_block_2]
    }
  
    tags = {
      Name = "db-sg"
    }
  }

  
  resource "aws_security_group" "EFS_sg" {
  
    vpc_id = aws_vpc.vpc.id
  
     ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
      Name = "EFS-sg"
    }
  }
 
 
 resource "aws_security_group" "ALB_sg" {
  
    vpc_id = aws_vpc.vpc.id
  
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
      Name = "ALB-SG"
    }
  }

  resource "aws_security_group" "ec2_sg" {
  
    vpc_id = aws_vpc.vpc.id
  
     ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
      Name = "ec2-sg"
    }
  }