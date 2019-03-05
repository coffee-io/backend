# resource

module "ingredients_resource" {
	source          = "./resource"
	rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
	name            = "ingredients"
}

# method

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id   = "${module.ingredients_resource.resource_id}"
  http_method   = "GET"
	authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id             = "${module.ingredients_resource.resource_id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:dynamodb:action/Query"
	credentials							= "${aws_iam_role.iam_for_dynamo.arn}"
	passthrough_behavior    = "WHEN_NO_TEMPLATES"

  request_templates = {
    "application/json" = <<EOF
{
    "TableName": "CoffeeConfig",
    "PrimaryKey": "key",
    "KeyConditionExpression": "configKey = :k",
    "ExpressionAttributeValues": {
        ":k": {
            "S": "ingredients"
        }
    }
}
EOF
  }
}


