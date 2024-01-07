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



