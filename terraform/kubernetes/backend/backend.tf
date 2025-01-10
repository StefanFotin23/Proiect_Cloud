# Define the namespace for the backend service
resource "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

output "service_name" {
  value = kubernetes_service.backend_service.metadata[0].name
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.backend.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "role"
                  operator = "In"
                  values   = ["server"]  # Affinity to run on the 'server' role node
                }
              }
            }
          }
        }

        container {
          name  = "backend"
          image = "${var.docker_username}/${var.docker_repo}-backend"

          port {
            container_port = var.server_port
          }

          env {
            name  = "SERVER_PORT"
            value = "${var.server_port}"
          }

          env {
            name  = "DB_URL"
            value = "jdbc:mysql://backend_database:${var.db_port}/${var.db_name}"
          }

          env {
            name  = "DB_USERNAME"
            value = "${var.db_username}"
          }

          env {
            name  = "DB_PASSWORD"
            value = "${var.db_password}"
          }

          env {
            name  = "JWT_EXPIRATION"
            value = "${var.jwt_expiration}"
          }

          env {
            name  = "JWT_SECRET"
            value = "${var.jwt_secret}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend_service" {
  metadata {
    name      = "backend-service"
    namespace = kubernetes_namespace.backend.metadata[0].name
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = var.server_port
      target_port = var.server_port
    }

    type = "ClusterIP"
  }
}
