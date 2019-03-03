resource "aws_api_gateway_method" "hello_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id   = "${aws_api_gateway_resource.hello.id}"
  http_method   = "GET"
	authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id             = "${aws_api_gateway_resource.hello.id}"
  http_method             = "${aws_api_gateway_method.hello_get.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.hello.arn}/invocations"
}

resource "aws_api_gateway_method_response" "hello_200" {
  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id = "${aws_api_gateway_resource.hello.id}"
  http_method = "${aws_api_gateway_method.hello_get.http_method}"
  status_code = "200"
	response_models {
		"application/json" = "Empty"
	}
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id = "${aws_api_gateway_resource.hello.id}"
  http_method = "${aws_api_gateway_method.hello_get.http_method}"
  status_code = "${aws_api_gateway_method_response.hello_200.status_code}"
	depends_on = ["aws_api_gateway_integration.hello_integration"]
}
