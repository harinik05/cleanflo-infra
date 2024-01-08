//List of things to implement: point_in_time_recovery, replica, server side encryption, stream_enabled , stream_view_type, s3 bucket source

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "PlantData"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UniqueID"
  range_key      = "SpeciesName"

  attribute {
    name = "UniqueID"
    type = "N"
  }

  attribute {
    name = "SpeciesName"
    type = "S"
    
  }

  attribute {
    name = "PopulationCount"
    type = "N"
  }
  stream_enabled  = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  //point in time recovery
  //keeps the data in a second timeline for 35 days
  point_in_time_recovery {
    enabled = true
  }
  
  global_secondary_index {
    name               = "SpeciesNameIndex"
    hash_key           = "SpeciesName"
    range_key          = "PopulationCount"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UniqueID"]
  }
    /*replica {
    region_name = "us-west-2"  # Replace with the desired region for the replica
    }*/

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}

