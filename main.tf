provider "aws"{
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

/*
module "s3"{
    source = "/Users/harinikarthik/Desktop/Waterloo/Leetcode/cleanflo-poc"
    bucket_name = "first_bucket_hk55555"
}*/