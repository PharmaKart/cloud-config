# ConfigMap for non-sensitive configuration
resource "kubernetes_config_map" "reminder_config" {
  metadata {
    name = "reminder-config"
    labels = {
      app = "pharmakart"
    }
  }

  data = {
    PORT          = "50055"
    DB_HOST       = var.database_endpoint
    DB_PORT       = var.db_port
    DB_NAME       = var.db_name
    SNS_TOPIC_ARN = var.sns_topic_arn
    SQS_QUEUE_URL = var.sqs_queue_url
  }
}

# Secret for sensitive configuration
resource "kubernetes_secret" "reminder_secrets" {
  metadata {
    name = "reminder-secrets"
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
resource "kubernetes_deployment" "reminder" {
  metadata {
    name = "reminder-deployment"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    replicas = var.reminder_replicas

    selector {
      match_labels = {
        app     = "pharmakart"
        service = "reminder"
      }
    }

    template {
      metadata {
        labels = {
          app     = "pharmakart"
          service = "reminder"
        }
      }

      spec {
        container {
          name  = "pharmakart-reminder"
          image = var.reminder_image

          image_pull_policy = "Always"

          port {
            name           = "api"
            container_port = 50055
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
              name = kubernetes_config_map.reminder_config.metadata[0].name
            }
          }

          # Mount all Secret values as environment variables
          env_from {
            secret_ref {
              name = kubernetes_secret.reminder_secrets.metadata[0].name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "reminder" {
  metadata {
    name = "reminder-service"
    labels = {
      app = "pharmakart"
    }
  }

  spec {
    selector = {
      app     = "pharmakart"
      service = "reminder"
    }

    port {
      protocol    = "TCP"
      port        = 50055
      target_port = 50055
    }
  }
}
