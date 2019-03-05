# resource

module "ingredients_resource" {
	source          = "./resource"
	rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
	name            = "ingredients"
}

# method

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id   = "${module.ingredients_resource.resource_id}"
  http_method   = "GET"
	authorization = "NONE"
}

/*
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id             = "${module.ingredients_resource.resource_id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}
*/
