# ConfigMap for non-sensitive configuration
resource "kubernetes_config_map" "authentication_config" {
  metadata {
    name = "authentication-config"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    PORT    = "50051"
    DB_HOST = var.database_endpoint
    DB_PORT = var.db_port
    DB_NAME = var.db_name
  }
}

# Secret for sensitive configuration
resource "kubernetes_secret" "authentication_secrets" {
  metadata {
    name = "authentication-secrets"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    JWT_SECRET  = var.jwt_secret
  }

  type = "Opaque"
}

# Modified Deployment to use ConfigMap and Secret
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

          # Mount all ConfigMap values as environment variables
          env_from {
            config_map_ref {
              name = kubernetes_config_map.authentication_config.metadata[0].name
            }
          }

          # Mount all Secret values as environment variables
          env_from {
            secret_ref {
              name = kubernetes_secret.authentication_secrets.metadata[0].name
            }
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
