# CleanFlo App
CleanFlo is a prototype that incorporates the devOps practices from IaC tool, TerraForm, and GitHub Actions to create an AWS infrastructure using AWS S3, AWS Lambdas, AWS DynamoDB, and AWS Glue. To describe the above services in detail, the AWS S3 was used for the upload of water quality data in local homes (given in txt format) as well as storing target/destination objects and python scripts. This python script was used to facilitate the ETL process of AWS Glue to convert the CSV data into data for the DynamoDB table. Once the indexes and GIS of table was defined, the configuration for a handler in NodeJS Lambda was made to run a counter job for all these services. Finally, this was seamlessly integrated through GitHub Actions to run the CI/CD pipeline. 

<p align="center">
    <img width="793" alt="Software Architecture Diagram of CleanFlo App" src="https://github.com/harinik05/cleanflo-poc/assets/63025647/17a954d6-25aa-444b-aac3-e2fc654a0339">
</p>




## ⚙️ Process

Setup

Features 


Challenges

Future Steps




