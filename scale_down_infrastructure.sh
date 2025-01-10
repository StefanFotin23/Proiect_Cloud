#!/bin/bash

# Define the namespaces and their corresponding deployments
namespaces=("auth" "backend" "frontend" "auth-database-adminer" "backend-database-adminer" "auth-database" "backend-database")
deployments=("auth" "backend" "frontend" "auth-database" "backend-database" "auth-database-adminer" "backend-database-adminer")

# Loop through each namespace and scale down the deployments
for namespace in "${namespaces[@]}"; do
    for deployment in "${deployments[@]}"; do
        echo "Scaling down deployment '$deployment' in namespace '$namespace' to 0 replicas..."
        kubectl scale deployment "$deployment" --replicas=0 -n "$namespace"
    done
done

kubectl get deployments --all-namespaces

echo "All deployments have been scaled down to 0 replicas."