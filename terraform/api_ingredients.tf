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

resource "aws_api_gateway_integration" "ingr_integration" {
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

resource "aws_api_gateway_method_response" "ingr_response_200" {
  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id = "${module.ingredients_resource.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "200"
	response_models {
		"application/json" = "Empty",
	}
	response_parameters = { 
		"method.response.header.Access-Control-Allow-Origin" = true,
	}
}

resource "aws_api_gateway_integration_response" "ingr_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  resource_id = "${module.ingredients_resource.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${aws_api_gateway_method_response.ingr_response_200.status_code}"
	response_parameters = {
		"method.response.header.Access-Control-Allow-Origin" = "'*'",
	}
  response_templates {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
[
    #foreach($elem in $input.path('$.Items[0].configValue.L')) {
        "name": "$elem.M.name.S",
        "type": "$elem.M.type.S",
        "color": "$elem.M.color.S",
        "cost": $elem.M.cost.N
    }#if($foreach.hasNext),#end
#end
]
EOF
	depends_on = ["aws_api_gateway_integration.ingr_integration"]
}
