## Requirements

AWS access credentials in environment variables

AWS configured with access credentials

Terraform binary

## Steps

## Create Policy

## Create Api And Data Base With IAM Policy And Assing Policy To Role

-- Create a file in the root dir:

 dev.tfvars

-- Copy and paste in the dev.tfvars:

table_name="table1" # Enter your table name
appsync_name="api1" # Enter your appsync name
table_arn="" # Enter your table name

-- Fill the table name and the appsync name with the same name 
that was registered in the previous branch

-- Enter the aws console copy and paste the arn of the table that was 
created and paste it in the table arn field

## Init Terraform

terraform init

## Run Terraform Validate

terraform validate

# Run Terraform Plan with vars

terraform plan -var-file dev.tfvars

# Run Terraform Apply with vars

terraform apply -var-file dev.tfvars -auto-approve


