
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "./python/"
output_path = "./python/hello-python.zip"
}


data "archive_file" "zip_the_js_code" {
type        = "zip"
source_dir  = "./nodejs/"
output_path = "./nodejs/zipped_folder.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "./python/hello-python.zip"
function_name                  = "Spacelift_Test_Lambda_Function"
role                           = "arn:aws:iam::accountnum:role/service-role/mylambdarole"
handler                        = "index.lambda_handler"
runtime                        = "python3.8"
}

resource "aws_lambda_function" "terraform_lambda_func_second" {
filename                       = "./nodejs/zipped_folder.zip"
function_name                  = "BucketAndDBCounter"
role                           = "arn:aws:iam::accountnum:role/service-role/mylambdarole"
handler                        = "index.handler"
runtime                        = "nodejs14.x" 
//source_code_hash = filebase64("./nodejs/zipped_folder.zip")  # Use filebase64 function to calculate hash

}
