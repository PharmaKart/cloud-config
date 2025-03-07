# ConfigMap for non-sensitive configuration
resource "kubernetes_config_map" "gateway_config" {
  metadata {
    name = "gateway-config"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    PORT                 = var.backend_port
    AUTH_SERVICE_URL     = "authentication-service:50051"
    PRODUCT_SERVICE_URL  = "product-service:50052"
    ORDER_SERVICE_URL    = "order-service:50053"
    PAYMENT_SERVICE_URL  = "payment-service:50054"
    REMINDER_SERVICE_URL = "reminder-service:50055"
    S3_BUCKET_NAME       = var.s3_bucket_name
    AWS_REGION           = var.aws_region
  }
}

# Secret for sensitive configuration
resource "kubernetes_secret" "gateway_secrets" {
  metadata {
    name = "gateway-secrets"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    STRIPE_WEBHOOK_SECRET = var.stripe_webhook_secret
  }

  type = "Opaque"
}

# Modified Deployment to use ConfigMap and Secret
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

          # Mount all ConfigMap values as environment variables
          env_from {
            config_map_ref {
              name = kubernetes_config_map.gateway_config.metadata[0].name
            }
          }

          # Mount all Secret values as environment variables
          env_from {
            secret_ref {
              name = kubernetes_secret.gateway_secrets.metadata[0].name
            }
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
