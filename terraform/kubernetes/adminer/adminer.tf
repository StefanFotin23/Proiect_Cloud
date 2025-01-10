resource "kubernetes_namespace" "adminer" {
  metadata {
    name = "adminer-${var.database_name}"  # Create a unique namespace for each Adminer instance
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_deployment" "adminer" {
  metadata {
    name      = "adminer-${var.database_name}"
    namespace = kubernetes_namespace.adminer.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "adminer-${var.database_name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "adminer-${var.database_name}"
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
          name  = "adminer-${var.database_name}"
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

resource "kubernetes_service" "adminer_service" {
  metadata {
    name      = "adminer-${var.database_name}"
    namespace = kubernetes_namespace.adminer.metadata[0].name
  }

  spec {
    selector = {
      app = "adminer-${var.database_name}"
    }

    port {
      port        = var.adminer_port      # Expose the dynamic port to the outside
      target_port = 8080                  # Map to the container's 8080 port
    }
  }
}
