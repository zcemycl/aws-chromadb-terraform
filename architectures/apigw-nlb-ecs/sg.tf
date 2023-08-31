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

resource "aws_iam_role" "chroma_ecs_task_role" {
  name               = "chroma_ecs_task_role"
  assume_role_policy = file("policies/ecs-task-role.json")
}

resource "aws_iam_policy" "chroma_ecs_autoscaling_policy" {
  name        = "chroma-autoscaling-policy"
  path        = "/"
  description = "Policy for triggering autoscaling policies"
  policy      = file("policies/ecs-autoscale-policy.json")
}

resource "aws_iam_role_policy_attachment" "chroma_ecs_autoscaling_policy_attachment" {
  role       = aws_iam_role.chroma_ecs_task_role.name
  policy_arn = aws_iam_policy.chroma_ecs_autoscaling_policy.arn
}

resource "aws_iam_role" "chroma_ecs_task_execution_role" {
  name               = "chroma-ecsTaskExecutionRole"
  assume_role_policy = file("policies/ecs-task-role.json")
}

resource "aws_iam_role_policy_attachment" "chroma_ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.chroma_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "chroma_cluster" {
  name = "chroma-cluster"
}

resource "aws_ecs_task_definition" "chroma_task_definition" {
  family                   = "chroma-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  execution_role_arn       = aws_iam_role.chroma_ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.chroma_ecs_task_role.arn

  container_definitions = jsonencode([
    {}
  ])
}
