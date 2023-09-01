resource "aws_lb" "lb" {
  name               = "load-balancer"
  internal           = true
  load_balancer_type = "network"
  subnets            = module.chroma_network.subnet_ids
}

resource "aws_lb_target_group" "lbtg" {
  name     = "load-balancer-target-group"
  port     = 8000
  protocol = "TCP"
  vpc_id   = aws_vpc.base_vpc.id

  health_check {
    enabled  = true
    protocol = "HTTP"
    path     = "/"
  }
}

resource "aws_lb_target_group_attachment" "lbtga" {
  target_group_arn = aws_lb_target_group.lbtg.arn
  target_id        = aws_instance.chroma_instance.id
  port             = 8000
}

resource "aws_lb_listener" "lbl" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "8000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lbtg.arn
  }
}
