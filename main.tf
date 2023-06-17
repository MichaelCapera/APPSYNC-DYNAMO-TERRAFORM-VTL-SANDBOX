# Define provider
provider "aws" {
  region = "us-east-1"
}

# Create Data Base
resource "aws_dynamodb_table" "example_table" {
  name         = "example-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

# Create AppSync API

resource "aws_appsync_graphql_api" "example" {
  name                = "example-api"
  authentication_type = "API_KEY"

  schema = file("schema.graphql")

}

# Create AppSync Api Key

resource "aws_appsync_api_key" "example" {
  api_id  = aws_appsync_graphql_api.example.id
  expires = "2023-12-31T23:59:59Z"
}

# Create Resolvers API
# Get Data
resource "aws_appsync_resolver" "get_resolver" {
  api_id            = aws_appsync_graphql_api.example.id
  type              = "Query"
  field             = "getExample"
  request_template  = file("${path.module}/resolvers/getData/get_resolver.req.vtl")
  response_template = file("${path.module}/resolvers/getData/get_resolver.res.vtl")

  data_source = aws_appsync_datasource.exampleDatasource.name

}

# Post Data

resource "aws_appsync_resolver" "post_resolver" {
  api_id            = aws_appsync_graphql_api.example.id
  type              = "Mutation"
  field             = "createRecord"
  request_template  = file("${path.module}/resolvers/postData/post_resolver.req.vtl")
  response_template = file("${path.module}/resolvers/postData/post_resolver.res.vtl")

  data_source = aws_appsync_datasource.exampleDatasource.name
}

# Put Data

resource "aws_appsync_resolver" "put_resolver" {
  api_id            = aws_appsync_graphql_api.example.id
  type              = "Mutation"
  field             = "updateRecord"
  request_template  = file("${path.module}/resolvers/putData/put_resolver.req.vtl")
  response_template = file("${path.module}/resolvers/putData/put_resolver.res.vtl")

  data_source = aws_appsync_datasource.exampleDatasource.name
}

resource "aws_appsync_resolver" "delete_resolver" {
  api_id            = aws_appsync_graphql_api.example.id
  field             = "deleteItem"
  type              = "Mutation"
  request_template  = file("${path.module}/resolvers/deleteData/delete_resolver.req.vtl")
  response_template = file("${path.module}/resolvers/deleteData/delete_resolver.res.vtl")

  data_source = aws_appsync_datasource.exampleDatasource.name
}

# Create IAM Policy

resource "aws_iam_policy" "appsync_dynamodb_policy" {
  name        = "AppSyncDynamoDBPolicy"
  description = "Policy to allow AppSync access to DynamoDB"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "${var.data_base_arn}"
    }
  ]
}
EOF
}

# Resource Rol

resource "aws_iam_role" "example_datasource_role" {
  name = "ExampleDataSourceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Assing Policy To Role

resource "aws_iam_role_policy_attachment" "appsync_policy_attachment" {
  role       = aws_iam_role.example_datasource_role.name
  policy_arn = aws_iam_policy.appsync_dynamodb_policy.arn
}


# Create Data Source

resource "aws_appsync_datasource" "exampleDatasource" {
  api_id           = aws_appsync_graphql_api.example.id
  name             = "exampleDatasource"
  type             = "AMAZON_DYNAMODB"
  service_role_arn = aws_iam_role.example_datasource_role.arn
  dynamodb_config {
    table_name = aws_dynamodb_table.example_table.name
  }
}
