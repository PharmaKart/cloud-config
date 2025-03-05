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
            value = "50055"
          }

          env {
            name  = "SNS_TOPIC_ARN"
            value = var.sns_topic_arn
          }

          env {
            name  = "SQS_QUEUE_URL"
            value = var.sqs_queue_url
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
