resource "aws_lb" "alb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups    = [aws_security_group.ALB_sg.id]
  subnets            = [aws_subnet.pub.id,aws_subnet.pub2.id]

  enable_deletion_protection = true
  tags = {
    task = "ALB"
    Name = "ALB"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
health_check {
    path                = "/" 
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_autoscaling_attachment" "alb_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app-tier-asg.name
  lb_target_group_arn = aws_lb_target_group.alb_tg.arn
}
