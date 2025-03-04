output "bastion_id" {
  description = "ID of the Bastion instance"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion instance"
  value       = aws_instance.bastion.public_ip
}

output "bastion_sg_id" {
  description = "ID of the Bastion security group"
  value       = aws_security_group.bastion_sg.id
}

output "bastion_role_arn" {
  description = "ARN of the Bastion IAM role"
  value       = aws_iam_role.bastion_role.arn
}
