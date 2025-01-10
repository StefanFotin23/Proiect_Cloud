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
}

module "auth" {
  source = "./kubernetes/auth"

  docker_username = var.docker_username
  docker_repo     = var.docker_repo
  replicas = var.global_replicas
  server_port = 8080
  db_name  = "backend-database"
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
  db_name  = "backend-database"
  db_username = var.db_username
  db_password = var.db_password
  db_root_password = var.db_root_password
  db_port = var.db_port
  jwt_expiration = var.jwt_expiration
  jwt_secret = var.jwt_secret
}

module "auth_database" {
  source = "./kubernetes/databases"

  db_name  = "auth-database"
  db_username = var.db_username
  db_password = var.db_password
  db_root_password = var.db_root_password
  db_port = var.db_port
  docker_username = var.docker_username
  docker_repo     = var.docker_repo
  replicas = var.global_replicas
}

module "backend_database" {
  source = "./kubernetes/databases"

  db_name = "backend-database"
  db_username = var.db_username
  db_password = var.db_password
  db_root_password = var.db_root_password
  db_port = var.db_port
  docker_username = var.docker_username
  docker_repo     = var.docker_repo
  replicas = var.global_replicas
}

module "auth_adminer" {
  source = "./kubernetes/adminer"

  database_name   = "auth-database"
  adminer_port    = 8088
  replicas = var.global_replicas
}

module "backend_adminer" {
  source = "./kubernetes/adminer"

  database_name   = "backend-database"
  adminer_port    = 8087
  replicas = var.global_replicas
}
