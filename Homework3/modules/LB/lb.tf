resource "aws_lb" "opsschool_lb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  #enable_deletion_protection = true

  access_logs {
    bucket  = var.s3_logs_bucket
    prefix  = "opsschool-lb"
    enabled = true
  }
}

resource "aws_lb_target_group" "target_server" {
  count = 2
  name     = "tf-target-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "target_server_attachement" {
  count = 2
  target_group_arn = element(aws_lb_target_group.target_server.*.arn, count.index)
  target_id        = element(var.server_id, count.index)
  port             = 80
}

resource "aws_lb_cookie_stickiness_policy" "sticky" {
  name                     = "sticky-policy"
  load_balancer            = aws_lb.opsschool_lb.id
  lb_port                  = 80
  cookie_expiration_period = 60
}