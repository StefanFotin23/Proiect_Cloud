resource "kubernetes_namespace" "backend-database" {
  metadata {
    name = "backend-database"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_deployment" "backend-database" {
  metadata {
    name      = "backend-database"
    namespace = kubernetes_namespace.backend-database.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "backend-database"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend-database"
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
          name  = "backend-database"
          image = "${var.docker_username}/${var.docker_repo}-database"

          env {
            name  = "MYSQL_DATABASE"
            value = "${var.db_name}"
          }

          env {
            name  = "MYSQL_USER"
            value = "${var.db_username}"
          }

          env {
            name  = "MYSQL_PASSWORD"
            value = "${var.db_password}"
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "${var.db_root_password}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend_database_service" {
  metadata {
    name      = "backend-database"
    namespace = kubernetes_namespace.backend-database.metadata[0].name
  }

  spec {
    selector = {
      app = "backend-database"
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}