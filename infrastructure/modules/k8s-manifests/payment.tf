resource "kubernetes_deployment" "payment" {
  metadata {
    name = "payment-deployment"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    replicas = var.payment_replicas

    selector {
      match_labels = {
        app     = "pharmakart"
        service = "payment"
      }
    }

    template {
      metadata {
        labels = {
          app     = "pharmakart"
          service = "payment"
        }
      }

      spec {
        container {
          name  = "pharmakart-payment"
          image = var.payment_image

          image_pull_policy = "Always"

          port {
            name           = "api"
            container_port = 50054
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
            name  = "DB_HOST"
            value = var.database_endpoint
          }

          env {
            name  = "DB_PORT"
            value = var.db_port
          }

          env {
            name  = "DB_USER"
            value = var.db_user
          }

          env {
            name  = "DB_PASSWORD"
            value = var.db_password
          }

          env {
            name  = "DB_NAME"
            value = var.db_name
          }

          env {
            name  = "PORT"
            value = "50054"
          }

          env {
            name  = "FRONTEND_URL"
            value = var.frontend_endpoint
          }

          env {
            name  = "STRIPE_SECRET_KEY"
            value = var.stripe_secret_key
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "payment" {
  metadata {
    name = "payment-service"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    selector = {
      app     = "pharmakart"
      service = "payment"
    }

    port {
      protocol    = "TCP"
      port        = 50054
      target_port = 50054
    }
  }
}
