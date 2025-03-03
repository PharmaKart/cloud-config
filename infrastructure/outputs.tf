output "db_endpoint" {
  value = module.rds.instance_endpoint
}

output "eks_alb_endpoint" {
  value = module.ingress-lb.load_balancer_hostname
}
