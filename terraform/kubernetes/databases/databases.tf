resource "kubernetes_namespace" "database" {
  metadata {
    name = var.db_name
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_deployment" "database" {
  metadata {
    name      = var.db_name
    namespace = kubernetes_namespace.database.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.db_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.db_name
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
          name  = "${var.db_name}"
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

resource "kubernetes_service" "database_service" {
  metadata {
    name      = var.db_name
    namespace = kubernetes_namespace.database.metadata[0].name
  }

  spec {
    selector = {
      app = var.db_name
    }

    port {
      port        = 3306
      target_port = 3306
    }
  }
}