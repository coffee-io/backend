# lambda

module "lambda_recalculate" {
	source          = "./lambda"
	name            = "recalculate"
	lambda_role_arn = "${aws_iam_role.iam_for_lambda.arn}"
}

# resource

module "cart_resource" {
  source          = "./resource"
  rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
  parent_id       = "${aws_api_gateway_rest_api.coffee.root_resource_id}"
  name            = "cart"
}

module "cart_calculator_resource" {
  source          = "./resource"
  rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
  parent_id       = "${module.cart_resource.resource_id}"
  name            = "calculator"
}

# methods

module "cart_calulator_put" {
	source					= "./api_method_lambda"
	rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
	resource_id     = "${module.cart_calculator_resource.resource_id}"
	http_method     = "PUT"
	lambda_arn      = "${module.lambda_recalculate.lambda_arn}"
}
