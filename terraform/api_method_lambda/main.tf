variable "rest_api_name"   {}
variable "resource_id"     {}
variable "http_method"     {}
variable "lambda_arn"      {}

data "aws_api_gateway_rest_api" "api" {
	name = "${var.rest_api_name}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${data.aws_api_gateway_rest_api.api.id}"
  resource_id   = "${var.resource_id}"
  http_method   = "${var.http_method}"
	authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${data.aws_api_gateway_rest_api.api.id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = "${data.aws_api_gateway_rest_api.api.id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "200"
	response_models {
		"application/json" = "Empty",
	}
	response_parameters = { 
		"method.response.header.Access-Control-Allow-Origin" = true,
	}
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = "${data.aws_api_gateway_rest_api.api.id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${aws_api_gateway_method_response.response_200.status_code}"
	response_parameters = {
		"method.response.header.Access-Control-Allow-Origin" = "'*'",
	}
	depends_on = ["aws_api_gateway_integration.integration"]
}
