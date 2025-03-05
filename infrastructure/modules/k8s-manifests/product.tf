resource "kubernetes_deployment" "product" {
  metadata {
    name = "product-deployment"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    replicas = var.product_replicas

    selector {
      match_labels = {
        app     = "pharmakart"
        service = "product"
      }
    }

    template {
      metadata {
        labels = {
          app     = "pharmakart"
          service = "product"
        }
      }

      spec {
        container {
          name  = "pharmakart-product"
          image = var.product_image

          image_pull_policy = "Always"

          port {
            name           = "api"
            container_port = 50052
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
        }
      }
    }
  }
}

resource "kubernetes_service" "product" {
  metadata {
    name = "product-service"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    selector = {
      app     = "pharmakart"
      service = "product"
    }

    port {
      protocol    = "TCP"
      port        = 50052
      target_port = 50052
    }
  }
}
