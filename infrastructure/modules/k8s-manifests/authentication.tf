resource "kubernetes_deployment" "authentication" {
  metadata {
    name = "authentication-deployment"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    replicas = var.authentication_replicas

    selector {
      match_labels = {
        app     = "pharmakart"
        service = "authentication"
      }
    }

    template {
      metadata {
        labels = {
          app     = "pharmakart"
          service = "authentication"
        }
      }

      spec {
        container {
          name  = "pharmakart-authentication"
          image = var.authentication_image

          image_pull_policy = "Always"

          port {
            name           = "api"
            container_port = 50051
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
            value = "50051"
          }

          env {
            name  = "JWT_SECRET"
            value = var.jwt_secret
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "authentication" {
  metadata {
    name = "authentication-service"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    selector = {
      app     = "pharmakart"
      service = "authentication"
    }

    port {
      protocol    = "TCP"
      port        = 50051
      target_port = 50051
    }
  }
}
