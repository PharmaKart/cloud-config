output "frontend_endpoint" {
  description = "The endpoint of the frontend service"
  value       = module.alb.alb_dns_name
}
