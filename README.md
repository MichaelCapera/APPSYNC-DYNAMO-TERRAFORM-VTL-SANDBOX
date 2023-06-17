## Requirements

AWS credentials in env vars

## Init Terraform

terraform init

## Run validate

terraform validate

## Run plan

terraform plan

## Run apply

terraform apply

## Crete in the project root the file

dev.tfvars

## Write in the tfvars the arn of the data base as a variable

data_base_arn="The data base arn here !!!!"

## Run terraform commands calling the variables

# Initialize terraform in the project

terraform init

# Validate terraform file syntax

terraform validate

# Plan with vars

terraform plan -var-file dev.tfvars

# Apply with vars

terraform apply -var-file dev.tfvars -auto-approve

