output "load_balancer_hostname" {
  description = "The DNS name of the load balancer"
  value       = data.kubernetes_resource.ingress_status.object.status.loadBalancer.ingress[0].hostname
}
