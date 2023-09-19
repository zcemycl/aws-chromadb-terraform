resource "aws_efs_file_system" "chroma_efs" {
  creation_token         = "index_data"
  availability_zone_name = var.aws_az
  tags = {
    Name = "chroma-ecs-fs"
  }
}

resource "aws_efs_mount_target" "chroma_mount" {
  file_system_id  = aws_efs_file_system.chroma_efs.id
  subnet_id       = module.chroma_network.subnet_ids[0]
  security_groups = [module.security_groups.security_groups["chroma"].id]
}

resource "aws_security_group" "efs" {
  name        = "efs-security-group"
  description = "Security group for EFS"
  vpc_id      = aws_vpc.base_vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.chroma_subnets_cidr
  }

  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.chroma_subnets_cidr
  }
  tags = {
    Name = "efs-sg"
  }
}

resource "aws_security_group_rule" "efs_ecs" {
  from_port                = 2049
  to_port                  = 2049
  security_group_id        = module.security_groups.security_groups["chroma"].id
  source_security_group_id = aws_security_group.efs.id
  type                     = "ingress"
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "efs_egress_ecs" {
  from_port                = 2049
  to_port                  = 2049
  security_group_id        = module.security_groups.security_groups["chroma"].id
  source_security_group_id = aws_security_group.efs.id
  type                     = "egress"
  protocol                 = "tcp"
}
