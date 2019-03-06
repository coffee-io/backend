# resource

module "ingredients_resource" {
  source          = "./resource"
  rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
  name            = "ingredients"
}

# method

module "igredients_get" {
	source					  = "./api_method_dynamo"
  rest_api_name     = "${aws_api_gateway_rest_api.coffee.name}"
  resource_id       = "${module.ingredients_resource.resource_id}"
  http_method       = "GET"
	role_arn          = "${aws_iam_role.iam_for_dynamo.arn}"
	request_template  = <<EOF
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
	response_template = <<EOF
#set($inputRoot = $input.path('$'))
[
    #foreach($elem in $input.path('$.Items[0].configValue.L')){
        "name": "$elem.M.name.S",
        "type": "$elem.M.type.S",
        "color": "$elem.M.color.S",
        "cost": $elem.M.cost.N
    }#if($foreach.hasNext), #end
#end

]
EOF
}
