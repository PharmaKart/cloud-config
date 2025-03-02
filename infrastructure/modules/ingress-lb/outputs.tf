output "alb_security_group_id" {
  description = "The ID of the security group attached to the ALB"
  value       = aws_security_group.alb_sg.id
}