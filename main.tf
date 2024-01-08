/*provider "aws"{
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}*/

terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }
 
 backend "s3" {
   region = "${var.region}"
   key    = "terraform.tfstate"
 }
}
 
provider "aws" {
 region = "${var.region}"
}
 
resource "aws_instance" "test_instance" {
 ami           = "ami-830c94e3"
 instance_type = "t2.nano"
 tags = {
   Name = "test_instance"
 }
}


