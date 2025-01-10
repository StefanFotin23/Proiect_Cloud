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