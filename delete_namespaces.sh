#!/bin/bash

# List of namespaces to delete
NAMESPACES=(
  "auth-database-adminer"
  "auth-database"
  "auth"
  "backend-database-adminer"
  "backend-database"
  "backend"
  "frontend"
)

# Delete each namespace
for namespace in "${NAMESPACES[@]}"; do
  echo "Deleting namespace: $namespace"
  kubectl delete namespace "$namespace"
done

kubectl get deployments --all-namespaces

echo "All specified namespaces have been deleted."
