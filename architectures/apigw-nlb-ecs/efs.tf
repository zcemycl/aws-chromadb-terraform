# resource "aws_efs_file_system" "chroma_efs" {
#     tags = {
#         Name = "chroma-ecs-fs"
#     }
# }

# resource "aws_efs_mount_target" "chroma_mount" {
#     file_system_id = aws_efs_file_system.chroma_efs.id
#     subnet_id = module.chroma_network.subnet_ids[0]
#     security_groups = [aws_security_group.efs.id, module.security_groups.chroma_sg_id]
# }

# resource "aws_security_group" "efs" {
#   name        = "efs-security-group"
#   description = "Security group for EFS"
#   vpc_id      = aws_vpc.base_vpc.id

#   ingress {
#     from_port = 2049
#     to_port   = 2049
#     protocol  = "tcp"
#     cidr_blocks = var.chroma_subnets_cidr
#   }

#   egress {
#     from_port = 2049
#     to_port   = 2049
#     protocol  = "tcp"
#     cidr_blocks = var.chroma_subnets_cidr
#   }
#     tags = {
#     Name = "efs-sg"
#   }
# }

# resource "aws_security_group_rule" "efs_ecs" {
#   from_port = 0
#   to_port = 0
# #   security_group_id =  module.model_vpc.security_group_ids[0]
#   security_group_id = module.security_groups.chroma_sg_id
# #   source_security_group_id = aws_security_group.efs.id
#   type =  "ingress"
#   self = true
#   protocol = "-1"
# }

# # resource "aws_network_acl" "nacl" {
# #   vpc_id = aws_vpc.base_vpc.id
# #   subnet_ids = module.chroma_network.subnet_ids

# #   ingress {
# #     rule_no = 100
# #     from_port = 1024
# #     to_port = 65535
# #     protocol = "tcp"
# #     cidr_block = "0.0.0.0/0"
# #     action = "allow"
# #   }

# #   egress {
# #     rule_no = 100
# #     from_port = 1024
# #     to_port = 65535
# #     protocol = "tcp"
# #     cidr_block = "0.0.0.0/0"
# #     action = "allow"
# #   }
# # }
