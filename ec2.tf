resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  availability_zone           = local.azs_names[0]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnets.*.id[0]
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
 #user_data = file("./scripts/httpd.sh")
  #user_data_replace_on_change = true
  iam_instance_profile = aws_iam_instance_profile.web_profile.name
  tags = {
    Name = "jhc-demo-${local.ws}"
  }
  provisioner "remote-exec" {
  inline = [
    "sudo mkdir -p /var/www/html",
    "sudo chown -R ec2-user:ec2-user /var/www/html",
    "sudo chmod -R 755 /var/www/html"
  ]
}
  provisioner "file" {
    source =  "./code/index.html"
    destination = "/var/www/html/index.html"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/Downloads/demo.pem")
    host = self.public_ip
  }
}

# creating security group for ec2 instance
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.web_ingress_rule
    content {
      description = "some description"
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

 

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# create IAM role for ec2 instance

resource "aws_iam_role" "web_role" {
  name = "web_role"
  managed_policy_arns = [ aws_iam_policy.web_policy.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

# create IAM policy for s3

resource "aws_iam_policy" "web_policy" {
  name = "web-policy-618033"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObjet","s3:putObjet"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::s3-nov-bucket-01/*"
      },
    ]
  })
}
# create iam instance profile for ec2

resource "aws_iam_instance_profile" "web_profile" {
  name = "web_profile"
  role = aws_iam_role.web_role.name
}