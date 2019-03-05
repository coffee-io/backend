# API

resource "aws_api_gateway_rest_api" "coffee" {
  name        = "coffee"
}

# deployment

resource "aws_api_gateway_deployment" "coffee_deployment" {
  depends_on = ["module.hello_method_get"]

  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  stage_name  = "prod"

	triggers {
		build_number = "${timestamp()}" 
	}
}
