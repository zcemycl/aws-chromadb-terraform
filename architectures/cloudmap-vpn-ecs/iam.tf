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
