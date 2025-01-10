#!/bin/bash

cd terraform/

terraform init

terraform plan -out=terraform.out

terraform apply "terraform.out"

# Run port-forward commands in the background and log their outputs
kubectl port-forward svc/frontend-service 4200:80 -n frontend > frontend-port-forward.log 2>&1 &
echo "Port-forward for frontend-service started in the background."

kubectl port-forward svc/auth-database-adminer 8087:8087 -n auth-database-adminer > auth-database-adminer-port-forward.log 2>&1 &
echo "Port-forward for auth-database-adminer started in the background."

kubectl port-forward svc/backend-database-adminer 8088:8088 -n backend-database-adminer > backend-database-adminer-port-forward.log 2>&1 &
echo "Port-forward for backend-database-adminer started in the background."