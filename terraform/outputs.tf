output "frontend_service_url" {
  value = module.frontend.service_name
}

output "auth_service_url" {
  value = module.auth.service_name
}

output "backend_service_url" {
  value = module.backend.service_name
}
