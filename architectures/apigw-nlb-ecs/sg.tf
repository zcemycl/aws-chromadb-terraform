module "security_groups" {
  source = "../../modules/security_groups"
  security_groups = [
    {
      name        = "chroma"
      description = "chroma security group"
      vpc_id      = aws_vpc.base_vpc.id
      ingress_rules = [
        {
          protocol    = "tcp"
          from_port   = 8000
          to_port     = 8000
          cidr_blocks = [aws_vpc.base_vpc.cidr_block]
        },
        {
          protocol    = "tcp"
          from_port   = 2049
          to_port     = 2049
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
