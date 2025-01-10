resource "kubernetes_namespace" "backend-adminer" {
  metadata {
    name = "${var.database_name}-adminer"  # Create a unique namespace for each Adminer instance
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_deployment" "backend-adminer" {
  metadata {
    name      = "${var.database_name}-adminer"
    namespace = kubernetes_namespace.backend-adminer.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "${var.database_name}-adminer"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.database_name}-adminer"
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
                  values   = ["client"]  # Affinity to run on the 'client' role node
                }
              }
            }
          }
        }

        container {
          name  = "${var.database_name}-adminer"
          image = "adminer"

          env {
            name  = "ADMINER_DEFAULT_SERVER"
            value = var.database_name  # Use the database name as the server
          }

          port {
            container_port = 8080  # Adminer typically runs on port 8080 inside the container
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend_adminer_service" {
  metadata {
    name      = "${var.database_name}-adminer"
    namespace = kubernetes_namespace.backend-adminer.metadata[0].name
  }

  spec {
    selector = {
      app = "${var.database_name}-adminer"
    }

    port {
      port        = var.adminer_port      # Expose the dynamic port to the outside
      target_port = 8080                  # Map to the container's 8080 port
    }

    type = "ClusterIP"
  }
}
