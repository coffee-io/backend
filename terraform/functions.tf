module "lambda_reset" {
	source          = "./lambda"
	name            = "reset"
	lambda_role_arn = "${aws_iam_role.iam_for_lambda.arn}"
}
