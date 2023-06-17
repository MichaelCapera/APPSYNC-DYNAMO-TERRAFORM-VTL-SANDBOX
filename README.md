## Requirements

AWS access credentials in environment variables

AWS configured with access credentials

Terraform binary

## Steps

## Create Resources

-- Checkout in the terminal to the branch create_resources

git checkout create_resources

## Create Api And Data Base

-- Create a file in the root dir:

 dev.tfvars

-- Copy and paste in the dev.tfvars:

table_name="table1" # Enter your table name
appsync_name="api1" # Enter your appsync name
table_arn=""        # Enter your table name

-- Fill the table name and the appsync name

## Init Terraform

terraform init

## Run Terraform Validate

terraform validate

# Run Terraform Plan with vars

terraform plan -var-file dev.tfvars

# Run Terraform Apply with vars

terraform apply -var-file dev.tfvars -auto-approve

# Checkout to the next branch 

git checkout create_database_policy

