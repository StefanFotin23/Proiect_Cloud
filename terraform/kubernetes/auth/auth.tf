# Define the namespace for the auth service
resource "kubernetes_namespace" "auth" {
  metadata {
    name = "auth"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

output "service_name" {
  value = kubernetes_service.auth_service.metadata[0].name
}

resource "kubernetes_deployment" "auth" {
  metadata {
    name      = "auth"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "auth"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth"
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
          name  = "auth"
          image = "${var.docker_username}/${var.docker_repo}-auth"

          port {
            container_port = var.server_port
          }

          env {
            name  = "SERVER_PORT"
            value = "${var.server_port}"
          }

          env {
            name  = "DB_URL"    
            value = "jdbc:mysql://${var.db_service_name}.${var.db_namespace}.svc.cluster.local:${var.db_port}/${var.db_name}"
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

resource "kubernetes_service" "auth_service" {
  metadata {
    name      = "auth-service"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  spec {
    selector = {
      app = "auth"
    }

    port {
      port        = var.server_port
      target_port = var.server_port
    }

    type = "ClusterIP"
  }
}
