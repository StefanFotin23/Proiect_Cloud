variable "jwt_secret" {
  description = "The secret key used to sign JWT tokens"
  type        = string
}

variable "db_username" {
  description = "The database username"
  type        = string
}

variable "db_password" {
  description = "The database password"
  type        = string
}

variable "db_root_password" {
  description = "The root database password"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_service_name" {
  description = "The service name of the database"
  type        = string
}

variable "db_namespace" {
  description = "The namespace of the database"
  type        = string
}

variable "db_port" {
  description = "The port for the database"
  type        = number
}

variable "server_port" {
  description = "The port for the database"
  type        = number
}

variable "jwt_expiration" {
  description = "JWT token expiration time"
  type        = number
}

variable "docker_username" {
  description = "Docker username for the image repository"
  type        = string
}

variable "docker_repo" {
  description = "Docker repository name for the frontend image"
  type        = string
}

variable "replicas" {
  description = "Number of service replicas"
  type = number
}