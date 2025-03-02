# Optional: Create a sample ingress resource (you can replace this with your actual ingress)
resource "kubernetes_ingress_v1" "pharmakart_ingress" {
  metadata {
    name = "pharmakart-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/security-groups"  = aws_security_group.alb_sg.id
      "alb.ingress.kubernetes.io/listen-ports"     = jsonencode([{ "HTTP" : 80 }])
      "alb.ingress.kubernetes.io/healthcheck-path" = "/health"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "gateway-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]
}
