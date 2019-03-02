resource "aws_lambda_function" "hello" {
  filename         = "hello.zip"
  function_name    = "hello_get"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "hello"
  source_code_hash = "${base64sha256(file("hello/hello.zip"))}"
  runtime          = "go1.x"
	memory_size			 = 128
}

resource "aws_cloudwatch_log_group" "hello" {
  name              = "/aws/lambda/${aws_lambda_function.hello.function_name}"
  retention_in_days = 14
}
