resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "cloud_pem" {
  filename = "ssh-chroma.pem"
  content  = tls_private_key.ssh_key.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 ssh-chroma.pem"
  }
}

resource "aws_security_group" "chroma_sg" {
  name = "chroma-instance-sg"
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "api-port"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "chroma_instance" {
  ami               = lookup(var.Region2AMI, var.aws_region)
  availability_zone = var.aws_az
  instance_type     = var.instance_type
  security_groups   = [aws_security_group.chroma_sg.name]
  key_name          = aws_key_pair.ssh_key.id

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 24
  }

  connection {
    host        = self.public_ip
    user        = "ec2-user"
    private_key = tls_private_key.ssh_key.private_key_pem
    timeout     = "10m"
  }

  provisioner "file" {
    source      = "../../docker-compose.yml"
    destination = "/home/ec2-user/docker-compose.yml"
  }

  provisioner "file" {
    source      = "../../setup-docker.sh"
    destination = "setup-docker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x setup-docker.sh",
      "sudo ./setup-docker.sh"
    ]
  }

  tags = {
    Name = "${var.author}-chroma-compute-sg"
  }
}
