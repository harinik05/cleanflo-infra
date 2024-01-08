# CleanFlo App
CleanFlo is a prototype that incorporates the devOps practices from IaC tool, TerraForm, and GitHub Actions to create an AWS infrastructure using AWS S3, AWS Lambdas, AWS DynamoDB, and AWS Glue. To describe the above services in detail, the AWS S3 was used for the upload of water quality data in local homes (given in txt format) as well as storing target/destination objects and python scripts. This python script was used to facilitate the ETL process of AWS Glue to convert the CSV data into data for the DynamoDB table. Once the indexes and GIS of table was defined, the configuration for a handler in NodeJS Lambda was made to run a counter job for all these services. Finally, this was seamlessly integrated through GitHub Actions to run the CI/CD pipeline. 

<p align="center">
    <img width="630" alt="Software Architecture Diagram of CleanFlo App" src="https://github.com/harinik05/cleanflo-poc/assets/63025647/58bf8cab-8ebc-4d54-8b7a-9039ffb2fff8">
</p>

## ⚙️ Process

### 1. AWS S3
Resource for AWS S3 bucket, waterquality10989760, was made to store the water quality data for local regions in txt format. Several configurations such as CORS headers, lifecycle_configuration, logging, replication, and versioning were enabled through the creation of resources in the `buckets.tf` file. Server-side encryption was enabled through the creation of symmetric key in AWS KMS. Then, the `sse_algorithm` was connected directly to this key and its corresponding id. Then, the files were uploaded through locals loop. 
```
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
```

Setup

Features 


Challenges

Future Steps




