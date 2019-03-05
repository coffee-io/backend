# API

resource "aws_api_gateway_rest_api" "coffee" {
  name        = "coffee"
}

# lambdas

module "lambda_hello" {
	source          = "./lambda"
	name            = "hello"
	lambda_role_arn = "${aws_iam_role.iam_for_lambda.arn}"
	runtime         = "python3.7"
}

# resources

module "resource" {
	source          = "./resource"
	rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
	name            = "hello"
	lambda_arn      = "${module.lambda_hello.lambda_arn}"
}

# deployment

resource "aws_api_gateway_deployment" "coffee_deployment" {
  depends_on = ["module.resource"]

  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  stage_name  = "prod"
}

