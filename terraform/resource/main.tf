variable "rest_api_name"   {}
variable "name"            {}
variable "lambda_arn"      {}

#
# api resource
#

data "aws_api_gateway_rest_api" "api" {
	name = "${var.rest_api_name}"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${data.aws_api_gateway_rest_api.api.id}"
  parent_id   = "${data.aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "${var.name}"
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "resource_apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${data.aws_api_gateway_rest_api.api.id}/*/*/*"
}

module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version = "0.2.0"

  api_id          = "${data.aws_api_gateway_rest_api.api.id}"
  api_resource_id = "${aws_api_gateway_resource.resource.id}"
}

#
# api resource methods
#

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${data.aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "ANY"
	authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${data.aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = "${data.aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
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
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${aws_api_gateway_method_response.response_200.status_code}"
	response_parameters = {
		"method.response.header.Access-Control-Allow-Origin" = "'*'",
	}
	depends_on = ["aws_api_gateway_integration.integration"]
}
