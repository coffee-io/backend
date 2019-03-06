# API

resource "aws_api_gateway_rest_api" "coffee" {
  name        = "coffee"
}

# deployment

resource "aws_api_gateway_deployment" "coffee_deployment" {
  depends_on = ["module.hello_method_get"]

  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  stage_name  = "prod"

	variables {
		deployed_at = "${timestamp()}"
	}
}

/*
resource "null_resource" "redeploy_api" {
	depends_on = ["aws_api_gateway_deployment.coffee_deployment"]
	provisioner "local-exec" {
		command = "aws apigateway update-deployment --rest-api-id ${aws_api_gateway_rest_api.coffee.id} --deployment-id ${aws_api_gateway_deployment.coffee_deployment.id}"
	}
	triggers {
		build_number = "${timestamp()}" 
	}
}
*/

resource "aws_api_gateway_base_path_mapping" "coffee" {
  api_id      = "${aws_api_gateway_rest_api.coffee.id}"
  stage_name  = "${aws_api_gateway_deployment.coffee_deployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.coffee.domain_name}"
}
