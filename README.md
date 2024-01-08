# CleanFlo App
CleanFlo is a prototype that incorporates the devOps practices from IaC tool, TerraForm, and GitHub Actions to create an AWS infrastructure using AWS S3, AWS Lambdas, AWS DynamoDB, and AWS Glue. To describe the above services in detail, the AWS S3 was used for the upload of water quality data in local homes (given in txt format) as well as storing target/destination objects and python scripts. This python script was used to facilitate the ETL process of AWS Glue to convert the CSV data into data for the DynamoDB tale. Once the indexes and GIS of table was defined, the configuration for a handler in NodeJS Lambda was made to run a counter job for all these services. Finally, this was seamlessly integrated through GitHub Actions to run the CI/CD pipeline. 

## ⚙️ Process

Setup

Features 


Challenges

Future Steps




