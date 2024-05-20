resource "aws_security_group" "web-sg" {
  name        = "Jenkins-Server-SG"
  description = "Open 22,443,80,8080,9000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-Server-sg"
  }
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = "t2.xlarge"
  key_name               = "roopak -mumbai"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data              = templatefile("./tools-install.sh", {})


  tags = {
    Name = "Jenkins-Server"
  }

}