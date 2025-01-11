#!/bin/bash

# Check if a replica count argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <replica-count>"
    exit 1
fi

# Get the replica count from the argument
REPLICA_COUNT=$1

# Define the namespaces and their corresponding deployments
namespaces=("auth" "backend" "frontend" "auth-database-adminer" "backend-database-adminer" "auth-database" "backend-database")
deployments=("auth" "backend" "frontend" "auth-database" "backend-database" "auth-database-adminer" "backend-database-adminer")

# Loop through each namespace and scale deployments to the specified replica count
for namespace in "${namespaces[@]}"; do
    for deployment in "${deployments[@]}"; do
        echo "Scaling deployment '$deployment' in namespace '$namespace' to $REPLICA_COUNT replicas..."
        kubectl scale deployment "$deployment" --replicas="$REPLICA_COUNT" -n "$namespace"
    done
done

kubectl get deployments --all-namespaces

echo "All deployments have been scaled to $REPLICA_COUNT replicas."
