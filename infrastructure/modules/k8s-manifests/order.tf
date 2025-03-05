resource "kubernetes_deployment" "order" {
  metadata {
    name = "order-deployment"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    replicas = var.order_replicas

    selector {
      match_labels = {
        app     = "pharmakart"
        service = "order"
      }
    }

    template {
      metadata {
        labels = {
          app     = "pharmakart"
          service = "order"
        }
      }

      spec {
        container {
          name  = "pharmakart-order"
          image = var.order_image

          image_pull_policy = "Always"

          port {
            name           = "api"
            container_port = 50053
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
            value = "50053"
          }

          env {
            name  = "PRODUCT_SERVICE_URL"
            value = "product-service:50052"
          }

          env {
            name  = "PAYMENT_SERVICE_URL"
            value = "payment-service:50054"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "order" {
  metadata {
    name = "order-service"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    selector = {
      app     = "pharmakart"
      service = "order"
    }

    port {
      protocol    = "TCP"
      port        = 50053
      target_port = 50053
    }
  }
}
