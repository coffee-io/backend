resource "aws_api_gateway_resource" "hello" {
  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  parent_id   = "${aws_api_gateway_rest_api.coffee.root_resource_id}"
  path_part   = "hello"
}

resource "aws_api_gateway_method" "hello_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id   = "${aws_api_gateway_resource.hello.id}"
  http_method   = "GET"
	authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id             = "${aws_api_gateway_resource.hello.id}"
  http_method             = "${aws_api_gateway_method.hello_get.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.hello.arn}/invocations"
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hello.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.coffee.id}/*/${aws_api_gateway_method.hello_get.http_method}/${aws_api_gateway_resource.hello.path}"
}
