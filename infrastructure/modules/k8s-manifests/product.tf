# ConfigMap for non-sensitive configuration
resource "kubernetes_config_map" "product_config" {
  metadata {
    name = "product-config"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    DB_HOST = var.database_endpoint
    DB_PORT = var.db_port
    DB_NAME = var.db_name
  }
}

# Secret for sensitive configuration
resource "kubernetes_secret" "product_secrets" {
  metadata {
    name = "product-secrets"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
  }

  type = "Opaque"
}

# Modified Deployment to use ConfigMap and Secret
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

          # Mount all ConfigMap values as environment variables
          env_from {
            config_map_ref {
              name = kubernetes_config_map.product_config.metadata[0].name
            }
          }

          # Mount all Secret values as environment variables
          env_from {
            secret_ref {
              name = kubernetes_secret.product_secrets.metadata[0].name
            }
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
