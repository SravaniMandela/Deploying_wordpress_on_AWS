resource "aws_autoscaling_group" "app-tier-asg" {
  name = "app-tier-workload"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  vpc_zone_identifier = [aws_subnet.private.id,aws_subnet.private2.id]
  launch_template {
    id = aws_launch_template.app-tier-lt.id
    version = aws_launch_template.app-tier-lt.latest_version
  }
  tag {
    key                 = "Name"
    value               = "app-tier-workload"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "app-tier-lt" {
  key_name = aws_key_pair.instance_key.key_name
  image_id = local.ami_id
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.app-instance-profile.name
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    mkdir -p /var/www/html
    sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0bc69eae47664510e.efs.us-east-1.amazonaws.com:/ /var/www/html

    sudo yum update -y
    sudo yum install -y httpd httpd-tools mod_ssl
    sudo systemctl enable httpd
    sudo systemctl start httpd

    # install php 7.4
    sudo amazon-linux-extras enable php7.4
    sudo yum clean metadata
    sudo yum install php php-common php-pear -y
    sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y

    # install mysql 5.7
    sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
    sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
    sudo yum install mysql-community-server -y
    sudo systemctl enable mysqld
    sudo systemctl start mysqld

    # set permissions
    sudo usermod -a -G apache ec2-user
    sudo chown -R ec2-user:apache /var/www
    sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
    sudo find /var/www -type f -exec sudo chmod 0664 {} \;
    sudo chown apache:apache -R /var/www/html

    # download wordpress files
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    sudo cp -r wordpress/* /var/www/html/

    # Install AWS CLI
    sudo yum install -y awscli

    # get the rds creds from the rds-master secret
    secret_value=$(aws secretsmanager get-secret-value --secret-id rds-master-creds --query SecretString --output text)
    db_host=$(echo $secret_value | jq -r '.host')
    db_username=$(echo $secret_value | jq -r '.username')
    db_password=$(echo $secret_value | jq -r '.password')
    db_name=$(echo $secret_value | jq -r '.dbname')
    
    # create the wp-config.php file
    sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    wp_config_file="/var/www/html/wp-config.php"
    sudo sed -i "s/database_name_here/$db_name/" $wp_config_file
    sudo sed -i "s/username_here/$db_username/" $wp_config_file
    sudo sed -i "s/password_here/$db_password/" $wp_config_file
    sudo sed -i "s/localhost/$db_host/" $wp_config_file
    sudo service httpd restart
    EOF
  )
     tags = {
      "Name" : "app-tier"
    
  }
}