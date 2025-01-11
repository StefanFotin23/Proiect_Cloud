variable "database_name" {
  description = "Name of the database (e.g., auth-database or backend-database)"
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

variable "adminer_port" {
  description = "The port for adminer"
  type        = number
}

variable "replicas" {
  description = "Number of service replicas"
  type = number
}