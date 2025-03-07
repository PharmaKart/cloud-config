# ConfigMap for non-sensitive configuration
resource "kubernetes_config_map" "order_config" {
  metadata {
    name = "order-config"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    PORT                = "50053"
    DB_HOST             = var.database_endpoint
    DB_PORT             = var.db_port
    DB_NAME             = var.db_name
    PRODUCT_SERVICE_URL = "product-service:50052"
    PAYMENT_SERVICE_URL = "payment-service:50054"
  }
}

# Secret for sensitive configuration
resource "kubernetes_secret" "order_secrets" {
  metadata {
    name = "order-secrets"
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

          # Mount all ConfigMap values as environment variables
          env_from {
            config_map_ref {
              name = kubernetes_config_map.order_config.metadata[0].name
            }
          }

          # Mount all Secret values as environment variables
          env_from {
            secret_ref {
              name = kubernetes_secret.order_secrets.metadata[0].name
            }
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
