resource "aws_instance" "ubuntu-instance" {
  ami           = var.ami
  instance_type = "t2.medium"
  key_name      = "ahmedkey"
  security_groups = ["${aws_security_group.UbuntuSG.name}"]

  tags  = {
    Name  = "CodeDeployEC2"
  }
  
  iam_instance_profile = aws_iam_instance_profile.codedeploy_instance_profile.name

  user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get install ruby -y
            apt-get install wget -y
            cd /home/ubuntu
            wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
            chmod +x ./install
            ./install auto
            service codedeploy-agent start
            EOF
}

resource "aws_elb" "web_lb" {
    name = "web-lb"
    availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
    security_groups = ["${aws_security_group.lb_sg.id}"]
    listener {
        instance_port = 80
        instance_protocol = "HTTP"
        lb_port = 80
        lb_protocol = "HTTP"
    }
    health_check {
        target = "HTTP:80/"
        interval = 30
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 2
    }
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400

    instances = [aws_instance.ubuntu-instance.id]
    tags = {
        Name = "web-lb"
    }
}