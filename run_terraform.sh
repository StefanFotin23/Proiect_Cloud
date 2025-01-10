#!/bin/bash

cd terraform/

terraform init

terraform plan -out=terraform.out

terraform apply "terraform.out"
