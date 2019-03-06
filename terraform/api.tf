# API

resource "aws_api_gateway_rest_api" "coffee" {
  name        = "coffee"
}

# deployment

resource "aws_api_gateway_deployment" "coffee_deployment" {
  depends_on = ["module.hello_method_get"]

  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  stage_name  = "prod"

	/*
	variables {
		deployed_at = "${timestamp()}"
	}
	*/
}

resource "null_resource" "redeploy_api" {
	depends_on = ["aws_api_gateway_deployment.coffee_deployment"]
	provisioner "local-exec" {
		command = "aws update-deployment --rest-api-id ${aws_api_gateway_rest_api.coffee.id} --deployment-id ${aws_api_gateway_deployment.coffee_deployment.id}"
	}
	triggers {
		build_number = "${timestamp()}" 
	}
}
