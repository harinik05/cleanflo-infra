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

