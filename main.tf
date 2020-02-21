provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/aashish/.aws/credentials"
  profile                 = "aashish"
}

resource "aws_launch_configuration" "default" {
  name                 = "new_instance"
  image_id             = "ami-0a887e401f7654935"
  instance_type        = "t2.micro"
  key_name             = "newaws"
  security_groups      = ["${aws_security_group.default.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.default.name}"
  user_data            = "${data.template_file.default.rendered}"
}

resource "aws_security_group" "default" {
  name        = "springboot-helloapp"
  description = "Allow TLS inbound"
  vpc_id      = "vpc-8f7656f5"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

data "aws_iam_policy_document" "default" {
  statement {
    sid = "1"
    actions = [
      "s3:List*",
      "s3:Get*",
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

resource "aws_iam_policy" "default" {
  name   = "terraform_access_helloapp"
  policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_role" "default" {
  name               = "terraform_access_helloapp"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}

resource "aws_iam_instance_profile" "default" {
  name = "terraform_access_helloapp"
  role = "${aws_iam_role.default.name}"
}

data "template_file" "default" {
  template = "${file("userdata.sh")}"
}

resource "aws_autoscaling_group" "default" {
  availability_zones = ["us-east-1a", "us-east-1f"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_configuration = "${aws_launch_configuration.default.name}"
}
