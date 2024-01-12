#in this template we are creating aws application laadbalancer and target group and alb http listener
resource "aws_alb" "alb" {
  name            = "mpulse-backend-sqa"
  subnets         = aws_subnet.public.*.id
  security_groups = [ aws_security_group.alb-sg.id ]
}

resource "aws_alb_target_group" "myapp-tg" {
  name        = "mpulse-backend-sqa-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.sqa-vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/"
    interval            = 30
  }
}

#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "testapp" {
  load_balancer_arn = aws_alb.alb.id
  port              = 80
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:acm:us-east-1:933085737869:certificate/b46d1f01-6617-4ac0-a46f-dc592c35bbf8"
  #enable above 2 if you are using HTTPS listner and change protocal from HTTPS to HTTPS
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.myapp-tg.arn
  }
}
