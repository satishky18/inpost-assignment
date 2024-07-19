resource "aws_launch_configuration" "web" {
  name            = "web-launch-configuration"
  image_id        = "ami-0c55b159cbfafe1f0"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web.id]
  user_data       = <<-EOF
          user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
}

resource "aws_autoscaling_group" "web" {
  launch_configuration = aws_launch_configuration.web.id
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = [aws_lb_target_group.web.arn]
}

resource "aws_security_group" "web" {
  vpc_id = var.vpc_id
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
}

resource "aws_lb" "web" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.web.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "web" {
  name     = "${var.lb_name}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
