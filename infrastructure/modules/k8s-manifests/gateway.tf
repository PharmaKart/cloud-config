resource "kubernetes_deployment" "gateway" {
  metadata {
    name = "gateway-deployment"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    replicas = var.gateway_replicas

    selector {
      match_labels = {
        app     = "pharmakart"
        service = "gateway"
      }
    }

    template {
      metadata {
        labels = {
          app     = "pharmakart"
          service = "gateway"
        }
      }

      spec {
        container {
          name  = "pharmakart-gateway"
          image = var.gateway_image

          image_pull_policy = "Always"

          port {
            name           = "api"
            container_port = var.backend_port
          }

          resources {
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }
            requests = {
              memory = "256Mi"
              cpu    = "250m"
            }
          }

          env {
            name  = "PORT"
            value = var.backend_port
          }

          env {
            name  = "AUTH_SERVICE_URL"
            value = "authentication-service:50051"
          }

          env {
            name  = "PRODUCT_SERVICE_URL"
            value = "product-service:50052"
          }

          env {
            name  = "ORDER_SERVICE_URL"
            value = "order-service:50053"
          }

          env {
            name  = "PAYMENT_SERVICE_URL"
            value = "payment-service:50054"
          }

          env {
            name  = "REMINDER_SERVICE_URL"
            value = "reminder-service:50055"
          }

          env {
            name  = "STRIPE_WEBHOOK_SECRET"
            value = var.stripe_webhook_secret
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "gateway" {
  metadata {
    name = "gateway-service"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    selector = {
      app     = "pharmakart"
      service = "gateway"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = var.backend_port
    }

    type = "NodePort"
  }
}
