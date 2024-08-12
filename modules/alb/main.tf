resource "aws_lb" "lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}  

resource "aws_lb_target_group" "target-group-site1" {
    health_check {
        interval            = 10
        path                = "/"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
    }
    name          = "site1"
    port          = 80
    protocol      = "HTTP"
    target_type   = "instance"
    vpc_id = var.vpc_id
}

resource "aws_lb_target_group" "target-group-site2" {
    health_check {
        interval            = 10
        path                = "/"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
    }
    name          = "site2"
    port          = 80
    protocol      = "HTTP"
    target_type   = "instance"
    vpc_id = var.vpc_id
}   

resource "aws_lb_listener" "alb-listener1" {
    load_balancer_arn = aws_lb.lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
      type = "redirect"

      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
}


resource "aws_lb_listener" "alb-listener2" {
    load_balancer_arn = aws_lb.lb.arn
    port              = 443
    protocol          = "HTTPS"
    certificate_arn = var.cert

    default_action {
        type = "forward"

        forward {
            target_group {
                arn    = aws_lb_target_group.target-group-site1.arn
                weight = 50
            }
            target_group {
                arn    = aws_lb_target_group.target-group-site2.arn
                weight = 50
            }
        }
    }
}

resource "aws_lb_listener_rule" "site1_rule" {
    listener_arn = aws_lb_listener.alb-listener2.arn
    priority     = 10

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.target-group-site1.arn
    }

    condition {
        path_pattern {
            values = ["/site1", "/site1/*"]
        }
    }
}

resource "aws_lb_listener_rule" "site2_rule" {
    listener_arn = aws_lb_listener.alb-listener2.arn
    priority     = 20

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.target-group-site2.arn
    }

    condition {
        path_pattern {
            values = ["/site2", "/site2/*"]
        }
    }
}



resource "aws_lb_target_group_attachment" "ec2_attach-site1" {
    target_group_arn = aws_lb_target_group.target-group-site1.arn
    target_id        = var.site1
}

resource "aws_lb_target_group_attachment" "ec2_attach-site2" {
    target_group_arn = aws_lb_target_group.target-group-site2.arn
    target_id        = var.site2
}