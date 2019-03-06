variable "rest_api_name"     {}
variable "resource_id"       {}
variable "http_method"       {}
variable "role_arn"          {}
variable "request_template"  {}
variable "response_template" {}

# method

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
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:dynamodb:action/Query"
  credentials             = "${var.role_arn}"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"

  request_templates = {
    "application/json" = "${var.request_template}"
  }
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

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = "${data.aws_api_gateway_rest_api.api.id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${aws_api_gateway_method_response.response_200.status_code}"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
  }
  response_templates {
    "application/json" = "${var.response_template}"
  }
  depends_on = ["aws_api_gateway_integration.integration"]
}

