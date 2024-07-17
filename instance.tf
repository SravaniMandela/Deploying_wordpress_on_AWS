resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "instance_key" {
  key_name   = "instance"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
resource "aws_secretsmanager_secret" "key_pair_secret_new" {
  name = "key_pair_secret_new"
}
resource "aws_secretsmanager_secret_version" "instance_key_version" {
  secret_string = tls_private_key.ssh_key.private_key_pem
  secret_id     = aws_secretsmanager_secret.key_pair_secret_new.id
}


    resource "aws_instance" "ec2" {
    ami           = local.ami_id
    instance_type = local.instance_type
    subnet_id     = aws_subnet.pub.id
    security_groups = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
    key_name      = aws_key_pair.instance_key.key_name
    tags = {
      Name = " EC2-public"
    }
    }
