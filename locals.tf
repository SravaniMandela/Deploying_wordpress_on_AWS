locals {
  front_tier_cidr_block_1 = "10.0.0.0/24"
  front_tier_cidr_block_2 = "10.0.1.0/24"
  app_tier_cidr_block_1 = "10.0.2.0/24"
  app_tier_cidr_block_2 = "10.0.3.0/24"
  db_tier_cidr_block_1 = "10.0.4.0/24"
  db_tier_cidr_block_2 = "10.0.5.0/24"
  vpc_cidr_block = "10.0.0.0/16"
  rds_user_name = "wordpress_aws"
  rds_db_name = "mydb"
  rds_name = "wordpress"
  region = "us-east-1"
  instance_type ="t2.micro"
  ami_id = "ami-0cf10cdf9fcd62d37"
  availability_zone = "us-east-1a"
  availability_zone2 = "us-east-1b"
}