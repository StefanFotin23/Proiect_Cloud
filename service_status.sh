#!/bin/bash

# Check if a namespace argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <namespace>"
    exit 1
fi

NAMESPACE=$1

# Get the list of pods in the specified namespace
PODS=$(kubectl get pods -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}')

# Check if there are any pods in the namespace
if [ -z "$PODS" ]; then
    echo "No pods found in namespace: $NAMESPACE"
    exit 1
fi

# Describe each pod
for POD in $PODS; do
    echo "Describing pod: $POD"
    kubectl describe pod $POD -n $NAMESPACE
    echo "-------------------------------------------------------------"
done
