resource "aws_elb" "op_lb" {
  name               = "test-lb-tf"
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

#     access_logs {
#     bucket        = "opsschool-dina-state-storage-s3"
#     interval      = 60
#   }
}


resource "aws_lb_target_group" "trgt_srvr" {
  count = 2
  name     = "trgt-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "trgt_srvr_att" {
  count = 2
  target_group_arn = element(aws_lb_target_group.trgt_srvr.*.arn, count.index)
  target_id        = element(var.server_id, count.index)
  port             = 80
}

resource "aws_lb_cookie_stickiness_policy" "sticky" {
  name                     = "sticky-policy"
  load_balancer            = aws_elb.op_lb.id
  lb_port                  = 80
  cookie_expiration_period = 60
}