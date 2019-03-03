# API

resource "aws_api_gateway_rest_api" "coffee" {
  name        = "coffee"
}

# resources

module "resource" {
	source        = "./resource"
	rest_api_name = "${aws_api_gateway_rest_api.coffee.name}"
	name          = "hello"
	// TODO - multiple responses
}

# deployment

resource "aws_api_gateway_deployment" "coffee_deployment" {
  depends_on = ["module.resource"]

  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  stage_name  = "prod"
}

