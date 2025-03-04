output "bastion_public_ip" {
  description = "The public IP address of the bastion host"
  value       = module.bastion.bastion_public_ip
}

output "backend_endpoint" {
  description = "The endpoint of the backend service"
  value       = module.ingress-lb.load_balancer_hostname
}

output "database_endpoint" {
  description = "The endpoint of the database"
  value       = module.rds.instance_endpoint
}

output "frontend_endpoint" {
  description = "The endpoint of the frontend service"
  value       = module.alb.alb_dns_name
}
