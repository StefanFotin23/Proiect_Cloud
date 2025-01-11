terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "kubernetes" {
  config_path = "~/.kube/config" # Path to your kubeconfig file
}

module "frontend" {
  source = "./kubernetes/frontend"

  docker_username = var.docker_username
  docker_repo     = var.docker_repo
  replicas = var.global_replicas
  auth_address = "auth-service.auth"
  backend_address = "backend-service.backend"
}

module "auth" {
  source = "./kubernetes/auth"

  docker_username = var.docker_username
  docker_repo     = var.docker_repo
  replicas = var.global_replicas
  server_port = 8080
  db_service_name = "auth-database"
  db_namespace = "auth-database"
  db_name  = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_root_password = var.db_root_password
  db_port = var.db_port
  jwt_expiration = var.jwt_expiration
  jwt_secret = var.jwt_secret
}

module "backend" {
  source = "./kubernetes/backend"

  docker_username = var.docker_username
  docker_repo     = var.docker_repo
  replicas = var.global_replicas
  server_port = 8082
  db_service_name = "backend-database"
  db_namespace = "backend-database"
  db_name  = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_root_password = var.db_root_password
  db_port = var.db_port
  jwt_expiration = var.jwt_expiration
  jwt_secret = var.jwt_secret
}

module "auth-database" {
  source = "./kubernetes/auth-database"

  db_name  = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_root_password = var.db_root_password
  db_port = var.db_port
  docker_username = var.docker_username
  docker_repo     = var.docker_repo
  replicas = var.global_replicas
}

module "backend-database" {
  source = "./kubernetes/backend-database"

  db_name  = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_root_password = var.db_root_password
  db_port = var.db_port
  docker_username = var.docker_username
  docker_repo     = var.docker_repo
  replicas = var.global_replicas
}

module "auth-adminer" {
  source = "./kubernetes/auth-adminer"

  database_name = "auth-database"
  db_service_name = "auth-database"
  db_namespace = "auth-database"
  adminer_port    = 8088
  replicas = var.global_replicas
}

module "backend-adminer" {
  source = "./kubernetes/backend-adminer"

  database_name = "backend-database"
  db_service_name = "backend-database"
  db_namespace = "backend-database"
  adminer_port    = 8087
  replicas = var.global_replicas
}
