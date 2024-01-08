resource "aws_lambda_function" "example" {
  function_name    = "example-lambda"
  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  handler          = "index.handler"
  role             = aws_iam_role.example.arn
  runtime          = "nodejs14.x"
}