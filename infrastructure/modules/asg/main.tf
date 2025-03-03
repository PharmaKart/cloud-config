data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.1.0"

  instance_type              = "t3.micro"
  use_mixed_instances_policy = true
  mixed_instances_policy = {
    instances_distribution = {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "price-capacity-optimized"
    }

    override = [
      {
        instance_type     = "t3.medium"
        weighted_capacity = "2"
      },
      {
        instance_type     = "t3.micro"
        weighted_capacity = "1"
      }
    ]
  }
  user_data = base64encode(
    <<-EOT
        #!/bin/bash

        cat <<'EOF' >> /etc/ecs/ecs.config
        ECS_CLUSTER=${var.ecs_cluster_name}
        ECS_LOGLEVEL=debug
        ECS_CONTAINER_INSTANCE_TAGS=${jsonencode({ Name = "ECS Instance" })}
        ECS_ENABLE_TASK_IAM_ROLE=true
        ECS_ENABLE_SPOT_INSTANCE_DRAINING=true
        EOF
    EOT
  )

  image_id = data.aws_ami.ecs_optimized.id

  security_groups = [aws_security_group.asg_sg.id]

  name                        = var.name
  create_iam_instance_profile = true

  iam_role_name        = "ecs-${var.name}-role"
  iam_role_description = "ECS role for ${var.name}"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  }

  vpc_zone_identifier = var.frontend_subnets
  health_check_type   = "EC2"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2

  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  tags = {
    Name      = var.name
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}
