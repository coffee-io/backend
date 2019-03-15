# resource

module "orders_resource" {
  source          = "./resource"
  rest_api_name   = "${aws_api_gateway_rest_api.coffee.name}"
  parent_id       = "${aws_api_gateway_rest_api.coffee.root_resource_id}"
  name            = "orders"
}

# method

module "orders_get" {
  source            = "./api_method_dynamo"
  rest_api_name     = "${aws_api_gateway_rest_api.coffee.name}"
  resource_id       = "${module.orders_resource.resource_id}"
  http_method       = "GET"
  role_arn          = "${aws_iam_role.iam_for_dynamo.arn}"
  action            = "Scan"
  request_template  = <<EOF
{
    "TableName": "CoffeeOrders"
}
EOF
  response_template = <<EOF
#set($inputRoot = $input.path('$'))
[
    #foreach($elem in $input.path('$.Items')){
        "id": "$elem.id.S",
        "orderDate": "$elem.orderDate.S",
        "total": $elem.total.N,
        "deliveryAddress": {
            "name": "$elem.deliveryAddress.M.name.S",
            "email": "$elem.deliveryAddress.M.email.S",
            "address": "$elem.deliveryAddress.M.address.S",
            "city": "$elem.deliveryAddress.M.city.S",
            "state": "$elem.deliveryAddress.M.state.S",
            "zip": "$elem.deliveryAddress.M.zip.S"
        },
        "items": [
            #foreach($item in $elem.items.L){
                "recipeName": "$item.M.recipeName.S",
                "size": "$item.M.size.S",
                "totalCost": $item.M.totalCost.N,
                "ingredients": [
                    #foreach($ing in $item.M.ingredients.L){
                        "name": "$ing.M.name.S",
                        "type": "$ing.M.type.S",
                        "cost": $ing.M.cost.N,
                        "color": "$ing.M.color.S",
                        "qtd": $ing.M.qtd.N,
                        "percentage": $ing.M.percentage.N
                    }#if($foreach.hasNext),
        #end
            #end
            ]
            }#if($foreach.hasNext),
    #end
#end

    ]
            }#if($foreach.hasNext),
    #end
#end

]
EOF
}
