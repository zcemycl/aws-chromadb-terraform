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
    {
      name        = "chroma-container"
      image       = "ghcr.io/chroma-core/chroma:0.4.7"
      essential   = true
      environment = []
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      mountPoints = [
        {
          containerPath : "/index_data"
          sourceVolume : aws_efs_file_system.chroma_efs.creation_token
          readOnly : false
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = module.loggings.chroma_log_group
          awslogs-stream-prefix = "chroma"
          awslogs-region        = var.aws_region
        }
      }
    }
  ])

  volume {
    name = aws_efs_file_system.chroma_efs.creation_token
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.chroma_efs.id
      root_directory = "/"
    }
  }

  ephemeral_storage {
    size_in_gib = var.fargate_ephemeral_storage_size
  }
}

resource "aws_ecs_service" "chroma_ecs_service" {
  name                               = "chroma-service"
  cluster                            = aws_ecs_cluster.chroma_cluster.id
  task_definition                    = aws_ecs_task_definition.chroma_task_definition.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups = [module.security_groups.chroma_sg_id]
    subnets         = module.chroma_network.subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lbtg.arn
    container_name   = "chroma-container"
    container_port   = 8000
  }

  depends_on = [
    aws_lb_listener.lbl,
    aws_lb_target_group.lbtg
  ]
}
