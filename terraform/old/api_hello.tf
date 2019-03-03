resource "aws_api_gateway_resource" "hello" {
  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  parent_id   = "${aws_api_gateway_rest_api.coffee.root_resource_id}"
  path_part   = "hello"
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "hello_apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hello.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.coffee.id}/*/*/*"
}

module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version = "0.2.0"

  api_id          = "${aws_api_gateway_rest_api.coffee.id}"
  api_resource_id = "${aws_api_gateway_resource.hello.id}"
}
