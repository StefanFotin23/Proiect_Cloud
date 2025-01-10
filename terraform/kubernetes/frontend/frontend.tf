# Define the namespace for the frontend service
resource "kubernetes_namespace" "frontend" {
  metadata {
    name = "frontend"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

output "service_name" {
  value = kubernetes_service.frontend_service.metadata[0].name
}

# Define the deployment for the frontend service
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.frontend.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
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
          name  = "frontend"
          image = "${var.docker_username}/${var.docker_repo}-frontend"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Define the service for the frontend service
resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.frontend.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.frontend.metadata[0].name
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"  # Change this to ClusterIP, NodePort, or LoadBalancer as needed
  }
}
