output "alb_sg_id" {
  description = "The ID of the security group for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "alb_target_group_arn" {
  description = "The ARN of the target group for the ALB"
  value       = module.alb.target_groups["${var.alb_name}-ecs-service"].arn
}
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.dns_name

}
