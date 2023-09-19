module "security_groups" {
  source = "../../modules/security_groups"
  security_groups = [
    {
      name        = "ec2-chroma"
      description = "Chroma instance security group"
      vpc_id      = aws_vpc.base_vpc.id
      ingress_rules = [
        {
          protocol    = "tcp"
          from_port   = 22
          to_port     = 22
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          protocol    = "tcp"
          from_port   = 8000
          to_port     = 8000
          cidr_blocks = [aws_vpc.base_vpc.cidr_block]
        }
      ]
      egress_rules = [
        {
          protocol    = "-1"
          from_port   = 0
          to_port     = 0
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    {
      name        = "ec2-backdoor"
      description = "Backdoor instance security group"
      vpc_id      = aws_vpc.base_vpc.id
      ingress_rules = [
        {
          protocol    = "tcp"
          from_port   = 22
          to_port     = 22
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [
        {
          protocol    = "-1"
          from_port   = 0
          to_port     = 0
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  ]
}

resource "aws_instance" "chroma_instance" {
  ami               = lookup(var.Region2AMI, var.aws_region)
  availability_zone = var.aws_az
  instance_type     = var.instance_type
  vpc_security_group_ids = [
    module.security_groups.security_groups["ec2-chroma"].id
  ]
  key_name = aws_key_pair.ssh_key.id

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 24
  }

  user_data = <<EOF
#!/bin/bash
curl -L https://raw.githubusercontent.com/zcemycl/aws-chromadb-terraform/main/docker-compose.yml -o /home/ec2-user/docker-compose.yml
curl -L https://raw.githubusercontent.com/zcemycl/aws-chromadb-terraform/main/setup-docker.sh -o setup-docker.sh
chmod +x setup-docker.sh
sudo ./setup-docker.sh
EOF
  subnet_id = module.chroma_network.subnet_ids[0]

  tags = {
    Name = "${var.author}-chroma-compute"
  }
}

resource "aws_instance" "backdoor_instance" {
  ami               = lookup(var.Region2AMI, var.aws_region)
  availability_zone = var.aws_az
  instance_type     = "t2.micro"
  subnet_id         = module.public_subnet_network.subnet_ids[0]
  vpc_security_group_ids = [
    module.security_groups.security_groups["ec2-backdoor"].id
  ]
  key_name                    = aws_key_pair.ssh_key.id
  associate_public_ip_address = true

  connection {
    host        = self.public_ip
    user        = "ec2-user"
    private_key = tls_private_key.ssh_key.private_key_pem
    timeout     = "10m"
  }

  provisioner "file" {
    source      = "ssh-chroma.pem"
    destination = "ssh-chroma.pem"
  }

  depends_on = [
    local_file.cloud_pem
  ]

  tags = {
    Name = "${var.author}-backdoor-compute"
  }
}
