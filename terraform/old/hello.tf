resource "aws_lambda_function" "hello" {
  function_name    = "hello_get"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "hello"
  runtime          = "go1.x"
	memory_size			 = 128
	s3_bucket        = "coffee-artifacts"
	s3_key           = "hello.zip"
}

resource "aws_cloudwatch_log_group" "hello" {
  name              = "/aws/lambda/${aws_lambda_function.hello.function_name}"
  retention_in_days = 14
}
