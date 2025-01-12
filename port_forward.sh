#!/bin/bash

# Run port-forward commands in the background and log their outputs
kubectl port-forward svc/frontend-service 4200:80 -n frontend > terraform/port_forward/frontend-port-forward.log 2>&1 &
echo "Port-forward for frontend-service started in the background."

kubectl port-forward svc/auth-database-adminer 8088:8088 -n auth-database-adminer > terraform/port_forward/auth-database-adminer-port-forward.log 2>&1 &
echo "Port-forward for auth-database-adminer started in the background."

kubectl port-forward svc/backend-database-adminer 8087:8087 -n backend-database-adminer > terraform/port_forward/backend-database-adminer-port-forward.log 2>&1 &
echo "Port-forward for backend-database-adminer started in the background."

kubectl port-forward svc/auth-service 8080:8080 -n auth > terraform/port_forward/auth-service-port-forward.log 2>&1 &
echo "Port-forward for auth-service started in the background."

kubectl port-forward svc/backend-service 8082:8082 -n backend > terraform/port_forward/backend-service-port-forward.log 2>&1 &
echo "Port-forward for backend-service started in the background."

kubectl port-forward svc/portainer 9000:9000 -n portainer > terraform/port_forward/portainer-service-port-forward.log 2>&1 &
echo "Port-forward for portainer started in the background."