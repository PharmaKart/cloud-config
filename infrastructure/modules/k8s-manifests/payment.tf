# ConfigMap for non-sensitive configuration
resource "kubernetes_config_map" "payment_config" {
  metadata {
    name = "payment-config"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    PORT         = "50054"
    DB_HOST      = var.database_endpoint
    DB_PORT      = var.db_port
    DB_NAME      = var.db_name
    FRONTEND_URL = var.frontend_endpoint
  }
}

# Secret for sensitive configuration
resource "kubernetes_secret" "payment_secrets" {
  metadata {
    name = "payment-secrets"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    DB_USER           = var.db_user
    DB_PASSWORD       = var.db_password
    STRIPE_SECRET_KEY = var.stripe_secret_key
  }

  type = "Opaque"
}

# Modified Deployment to use ConfigMap and Secret
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

          # Mount all ConfigMap values as environment variables
          env_from {
            config_map_ref {
              name = kubernetes_config_map.payment_config.metadata[0].name
            }
          }

          # Mount all Secret values as environment variables
          env_from {
            secret_ref {
              name = kubernetes_secret.payment_secrets.metadata[0].name
            }
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
