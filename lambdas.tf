
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "./python/"
output_path = "./python/hello-python.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "./python/hello-python.zip"
function_name                  = "Spacelift_Test_Lambda_Function"
role                           = "arn:aws:iam::720479364235:role/service-role/mylambdarole"
handler                        = "index.lambda_handler"
runtime                        = "python3.8"
}