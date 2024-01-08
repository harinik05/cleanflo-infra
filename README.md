# CleanFlo App 🏞️💦
CleanFlo is a prototype that incorporates the devOps practices from IaC tool, TerraForm, and GitHub Actions to create an AWS infrastructure using AWS S3, AWS Lambdas, AWS DynamoDB, and AWS Glue. To describe the above services in detail, the AWS S3 was used for the upload of water quality data in local homes (given in txt format) as well as storing target/destination objects and python scripts. This python script was used to facilitate the ETL process of AWS Glue to convert the CSV data into data for the DynamoDB table. Once the indexes and GIS of table was defined, the configuration for a handler in NodeJS Lambda was made to run a counter job for all these services. Finally, this was seamlessly integrated through GitHub Actions to run the CI/CD pipeline. 

<p align="center">
    <img width="630" alt="Software Architecture Diagram of CleanFlo App" src="https://github.com/harinik05/cleanflo-poc/assets/63025647/58bf8cab-8ebc-4d54-8b7a-9039ffb2fff8">
</p>

## 🖥️ Dependencies & Setup

### Programmatic setup of AWS with Visual Studio Code
1. Install the `AWS Toolkit extension` from VS Code
2. Enter the Access Key and Secret Key along with the username
3. Clone this repository and place it in a folder

### Running as IaC
1. Install HomeBrew on Mac 
2. Add it as an environmental variable to your paths
3. Install Terraform `brew install terraform`
4. Run all of these commands and check if the resources has been created
```
terraform init
terraform plan
terraform apply
terraform destroy
```
Optional: Add the variables from `variables.tf` as environmental variables using `export TF_VAR_<VAR_NAME> = "value"`

### CI/CD Integration with Github Actions
1. Commit a change to the repository
2. Include the Access key and secret key in repository secrets of settings in the repo
3. Workflow file will automatically execute in `Actions`

## ⚙️ Process

### 1. AWS S3
Resource for AWS S3 bucket, waterquality10989760, was made to store the water quality data for local regions in txt format. Several configurations such as CORS headers, lifecycle_configuration, logging, replication, and versioning were enabled through the creation of resources in the `buckets.tf` file. Server-side encryption was enabled through the creation of symmetric key in AWS KMS. Then, the `sse_algorithm` was connected directly to this key and its corresponding id. Finally, the files were uploaded through locals loop that goes through every single file in the `WaterQuality` folder directory. This also includes the csv file collection for the AWS DynamoDB data (available later). 
```
locals {
  files_to_upload = fileset("./WaterQuality", "**/*.txt")  # Replace with your desired local directory and file pattern
}

resource "aws_s3_bucket_object" "uploaded_objects" {
  for_each = local.files_to_upload

  bucket = "${var.bucket_name}"
  key    = each.value
  source = "./WaterQuality/${each.value}" 
  acl    = "private"  
  content_type = "text/plain"
}
```

### 2. AWS Glue
Initially, the `aws_glue_catalog_database` was defined to store the information about every transformation that is being made through the script. This was facilitated by the `aws_glue_catalog_table` resource, which defines the Plants.csv table sourced from the S3 bucket. The AWS glue job will be able to transform this Plants.csv file into the DynamoDB using the python script locted in the scripts_waters bucket. 

The python script uses the AWS Glue library and pySpark for ETL operations to transform the CSV data. Once the source path was defined, a DynamicFrame is created from the AWS Glue library for the csv file, and then `select_fields` was used to apply transformation for all the columns from the source table. Then, this was converted to Spark DataFrame to be written to the DynamoDB table using Apache Spark and DynamoDB connector. 

### 3. AWS DynamoDB
The resource for DynamoDB table was created to incorporate various features such as TTL, point-in-time recovery, and streams for new and old images. The primary key was set up through `UniqueID` (hash key) and `SpeciesName` (range key). Then, the secondary key setup was completed through `SpeciesName` as hashkey and `PopulationCount` as range key. 

### 4. AWS Lambda
The source code was indicated in the filename section along with the appropriate entry point (handler) and runtime (language). Initially, a data (archieve_file) was built as a zip folder before exporting it to AWS Lambda. 

## 🏔️ Challenges
### Configuration Drift Attributes
TerraForm is known for its declarative nature and immutable infrastructure, which 
1. Configuration drift attribute

3. Idempotent problem with AWS Glue and DynamoDB connector

Future Steps




