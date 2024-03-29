/*
Creation of first bucket which is to store information about 
local water quality
*/
resource "aws_s3_bucket" "waterquality10989760"{
    bucket = "${var.bucket_name}"
    acl = "${var.acl_value}"
}

/*
Resource to set up the CORS configuration of waterquality10989760 bucket
allowed_headers: Any HTTP header is allowed to make a request to the S3 bucket
allowed_methods: All of the HTTP methods are allowed when making requrests
allowed_origins: All origins allowed
expose_headers: Etag is used for caching and conditional requests
max_age_seconds: max time (secs) for pre-flight request (before actual request) to be 
cached
*/
resource "aws_s3_bucket_cors_configuration" "waterquality10989760_cors" {
  bucket = aws_s3_bucket.waterquality10989760.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

/*
Resource to set up the lifecycle configuration
expire_old_versions is true so it will be deleted after 30 days
status: specifies if the lifecycle rule has been enabled or not
expiration: after 30 days, all resources in bucket will be removed
*/
resource "aws_s3_bucket_lifecycle_configuration" "waterquality10989760_lifecycle" {
  bucket = aws_s3_bucket.waterquality10989760.bucket
  rule {
    id     = "expire_old_versions"
    status = "Enabled"
    expiration {
      days = 30  # Objects will be deleted after 30 days
    }
  }
}

/*
Resource to set up the bucket logging
target_bucket: S3 bucket thats going to receive the logs
target_prefix: The prefix to log the object keys
*/
resource "aws_s3_bucket_logging" "waterquality10989760_logging" {
  bucket = aws_s3_bucket.waterquality10989760.bucket
  target_bucket = "${var.target_bucket_name}"  # Replace with the target bucket for logs
  target_prefix = "logs/"  # Replace with the desired prefix for log object keys
}


# Create IAM role for S3 bucket replication
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Create the destination S3 bucket
resource "aws_s3_bucket" "destination_bucket" {
  bucket = "${var.destination_bucket_name}"
  acl    = "${var.acl_value}"
}


# Enable versioning on the destination bucket
resource "aws_s3_bucket_versioning" "destination_bucket_versioning" {
  bucket = "${var.destination_bucket_name}"
  versioning_configuration {
    status = "Enabled"
  }
}

/*
Resource for aws_s3_bucket_request_payment_configuration
Costs of data transfers can be paid by requester or BucketOwner
*/
resource "aws_s3_bucket_request_payment_configuration" "bucket_payment_configuration" {
  bucket = "${var.bucket_name}"
  payer  = "BucketOwner"  # Valid values are "BucketOwner" or "Requester"
}

/*
Implement server side encyryption
*/

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse_configuration" {
  bucket = "${var.bucket_name}"

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      kms_master_key_id = "${var.kms_key_id}"
    }
  }
}

//putting objects in the S3 bucket
locals {
  files_to_upload = fileset("./WaterQuality", "**/*.txt")  # Replace with your desired local directory and file pattern
}

resource "aws_s3_bucket_object" "uploaded_objects" {
  for_each = local.files_to_upload

  bucket = "${var.bucket_name}"
  key    = each.value
  source = "./WaterQuality/${each.value}"  # Replace with the local directory path
  acl    = "private"  # Specify the ACL for the uploaded files, e.g., private, public-read, etc.

  # Optional: Set content_type if needed
  content_type = "text/plain"
}
/*
//here is the IAM role for giving full access
resource "aws_iam_role" "s3_upload_role" {
  name = "s3-upload-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"  # Assuming it's used by EC2, adjust if needed
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_upload_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  # Replace with your desired S3 policy ARN
  role       = aws_iam_role.s3_upload_role.name //role
}*/

resource "aws_s3_bucket_object" "csv_object" {
  bucket = "${var.bucket_name}"
  key    = "plants_new.csv"  # Replace with the key of your CSV file in the S3 bucket
  acl    = "private"
  source = "./Species_Data/plants.csv"  # Replace with the local path to your CSV file
}
