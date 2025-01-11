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

variable "auth_address" {
  description = "Ip Address for the auth service"
  type        = string
}

variable "backend_address" {
  description = "Ip Address for the backend service"
  type        = string
}