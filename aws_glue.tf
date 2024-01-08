resource "aws_glue_catalog_database" "csv_database" {
  name = "dynamodb_csv_database"
}

resource "aws_glue_catalog_table" "csv_table" {
  database_name = aws_glue_catalog_database.csv_database.name
  name          = "dynamodb_csv_table"
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "classification" = "csv"
    "delimiter"      = ","
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location = aws_s3_bucket_object.csv_object.bucket
  }
}
/*
resource "aws_glue_job" "csv_to_dynamodb_etl" {
  name         = "csv_to_dynamodb_etl"
  role_arn     = "arn:aws:iam::720479364235:role/AWS_Service_Role" 

  command {
    name            = "glueetl"
    script_location = "s3://your-scripts-bucket/csv_to_dynamodb_etl_script.py"
  }

  default_arguments = {
    "--S3_INPUT_PATH"       = "s3://waterquality10989760"
    "--DYNAMODB_TABLE_NAME" = aws_dynamodb_table.basic-dynamodb-table.name
  }
}*/

resource "aws_glue_job" "etl_job" {
  name         = "csv_to_dynamodb_etl"
  role_arn     = "arn:aws:iam::720479364235:role/AWS_Service_Role"  # Replace with the ARN of your AWS Glue role
  command {
    name     = "glueetl"
    script_location = "s3://scripts-bucket-waters/csv_to_dynamodb_etl_script.py"  # Replace with the S3 path to your ETL script
  }

  default_arguments = {
    "--DYNAMODB_TABLE_NAME" = aws_dynamodb_table.basic-dynamodb-table.name
    "--S3_OUTPUT_PATH"      = "s3://waterquality10989760"  # Replace with the S3 path for Glue job output
  }
}

/*
resource "aws_glue_connection" "csv_glue_connection" {
  name = "dynamodb_csv_connection"
  physical_connection_requirements {
    availability_zone = "us-west-2a"
    security_group_id_list = ["sg-0123456789abcdef0"]
    subnet_id = "subnet-0123456789abcdef0"
  }
  connection_properties = {
    "JDBC_CONNECTION_URL" = aws_dynamodb_table.basic-dynamodb-table.stream_arn
  }
}
*/