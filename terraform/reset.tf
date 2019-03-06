module "lambda_reset" {
	source          = "./lambda"
	name            = "reset"
	lambda_role_arn = "${aws_iam_role.iam_for_lambda.arn}"
}

# invoke every day at midnight

resource "aws_cloudwatch_event_rule" "reset" {
	name 								= "reset_at_midnight"
	description					=	"Reset the database at midnight"
	schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "reset" {
	rule = "${aws_cloudwatch_event_rule.reset.id}"
	arn  = "${module.lambda_reset.lambda_arn}"
}

resource "aws_lambda_permission" "event_reset" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda_reset.lambda_arn}"
  principal     = "events.amazonaws.com"

  source_arn = "${aws_cloudwatch_event_rule.reset.arn}"
}
