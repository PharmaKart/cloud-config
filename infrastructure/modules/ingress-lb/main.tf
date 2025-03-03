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

resource "aws_security_group_rule" "allow_alb_to_node" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = var.node_security_group_id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "Allow traffic from ALB to node port 8080"
  depends_on               = [kubernetes_ingress_v1.pharmakart_ingress]
}

resource "time_sleep" "wait_for_ingress" {
  create_duration = "1m"
  depends_on      = [kubernetes_ingress_v1.pharmakart_ingress]
}

data "kubernetes_resource" "ingress_status" {
  api_version = "networking.k8s.io/v1"
  kind        = "Ingress"

  metadata {
    name      = kubernetes_ingress_v1.pharmakart_ingress.metadata[0].name
    namespace = kubernetes_ingress_v1.pharmakart_ingress.metadata[0].namespace
  }

  depends_on = [
    time_sleep.wait_for_ingress
  ]
}
