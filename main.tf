resource "aws_instance" "ci-cd" {
    ami = "ami-084568db4383264d4"
    count = 2
    instance_type = "t2.medium"
    key_name = aws_key_pair.deployer_key.key_name
    vpc_security_group_ids = [aws_security_group.ssh_sg.id]

    root_block_device {
    volume_size = 30              # in GB
    volume_type = "gp3"
    delete_on_termination = true
  }
    # provisioner "remote-exec" {
    #   inline = [ 
    #     "sudo apt-get update"
    #    ]
    #    connection {
    #      type = "ssh"
    #      user = "ec2-user"
    #      private_key = tls_private_key.ssh_key.private_key_pem
    #      host = self.public_ip
    #    }
    #    on_failure = continue

    # }
  
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

resource "aws_key_pair" "deployer_key" {
  key_name = "deployer_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/deployer_key.pem"
  file_permission = "0600"
}

resource "aws_security_group" "ssh_sg" {
  name = "ssh-access"

  ingress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP 3000-10000"
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP 6443"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTPS"
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP 30000-32767"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
