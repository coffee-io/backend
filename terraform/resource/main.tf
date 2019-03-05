variable "rest_api_name"   {}
variable "name"            {}

data "aws_api_gateway_rest_api" "api" {
	name = "${var.rest_api_name}"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${data.aws_api_gateway_rest_api.api.id}"
  parent_id   = "${data.aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "${var.name}"
}

module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version = "0.2.0"

  api_id          = "${data.aws_api_gateway_rest_api.api.id}"
  api_resource_id = "${aws_api_gateway_resource.resource.id}"
}

output "resource_id" {
	value = "${aws_api_gateway_resource.resource.id}"
}
