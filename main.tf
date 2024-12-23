provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0e2c8caa4b6378d8c" # Updated AMI ID
  instance_type = "t2.micro"
  key_name      = "nvn_rag" # Updated key name
}

resource "aws_autoscaling_group" "asg" {
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = ["subnet-0f8b23055458ee582"] # Updated subnets
  
}

resource "aws_launch_template" "lt" {
  image_id      = "ami-0e2c8caa4b6378d8c" # Updated AMI ID
  instance_type = "t2.micro"
  key_name      = "nvn_rag" # Updated key name
}

resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0f8b23055458ee582", "subnet-07c9c95ba8970800f"] # Updated subnets
}

resource "aws_route53_record" "dns" {
  zone_id = "Z08649022WAE3HGH4I0BM" # Updated hosted zone ID
  name    = "nvnrag321.com" # Updated domain name
  type    = "A"

  alias {
    name                   = aws_lb.my_lb.dns_name
    zone_id                = aws_lb.my_lb.zone_id
    evaluate_target_health = false
  }
}
