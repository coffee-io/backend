# lambda

module "lambda_hello" {
	source          = "./lambda"
	name            = "hello"
	lambda_role_arn = "${aws_iam_role.iam_for_lambda.arn}"
}

# resource

module "hello_resource" {
	source          = "./resource"
	rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
	name            = "hello"
}

# methods

module "hello_method_get" {
	source					= "./method"
	rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
	resource_id     = "${module.hello_resource.resource_id}"
	method          = "GET"
	lambda_arn      = "${module.lambda_hello.lambda_arn}"
}
