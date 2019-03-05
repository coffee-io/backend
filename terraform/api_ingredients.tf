# lambda

module "lambda_ingredients" {
	source          = "./lambda"
	name            = "ingredients"
	lambda_role_arn = "${aws_iam_role.iam_for_lambda.arn}"
}

# resource

module "ingredients_resource" {
	source          = "./resource"
	rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
	name            = "ingredients"
}

# methods

module "ingredients_method_get" {
	source					= "./method"
	rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
	resource_id     = "${module.ingredients_resource.resource_id}"
	method          = "GET"
	lambda_arn      = "${module.lambda_ingredients.lambda_arn}"
}

