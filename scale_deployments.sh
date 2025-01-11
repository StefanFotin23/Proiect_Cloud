#!/bin/bash

# Check if a replica count argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <replica-count>"
    exit 1
fi

# Get the replica count from the argument
REPLICA_COUNT=$1

kubectl scale deployment auth --replicas="$REPLICA_COUNT" -n auth
kubectl scale deployment backend --replicas="$REPLICA_COUNT" -n backend
kubectl scale deployment frontend --replicas="$REPLICA_COUNT" -n frontend
kubectl scale deployment auth-database-adminer --replicas="$REPLICA_COUNT" -n auth-database-adminer
kubectl scale deployment backend-database-adminer --replicas="$REPLICA_COUNT" -n backend-database-adminer
kubectl scale deployment auth-database --replicas="$REPLICA_COUNT" -n auth-database
kubectl scale deployment backend-database --replicas="$REPLICA_COUNT" -n backend-database
kubectl scale deployment portainer --replicas="$REPLICA_COUNT" -n portainer

sleep 5

kubectl get deployments --all-namespaces

echo "All deployments have been scaled to $REPLICA_COUNT replicas."
