#!/bin/bash

cd terraform/

kind delete cluster --name kind
kind create cluster --config kind-config.yaml