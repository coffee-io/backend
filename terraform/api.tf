resource "aws_api_gateway_rest_api" "coffee" {
  name        = "coffee"
}

resource "aws_api_gateway_deployment" "coffee_deployment" {
  depends_on = ["aws_api_gateway_integration.hello_integration"]

  rest_api_id = "${aws_api_gateway_rest_api.coffee.id}"
  stage_name  = "prod"
}

# domain

data "aws_acm_certificate" "cert" {
    domain   = "*.gamesmith.co.uk"
    statuses = ["ISSUED"]
}

data "aws_route53_zone" "main" {
	name         = "gamesmith.co.uk."
}

resource "aws_api_gateway_domain_name" "coffee" {
	certificate_arn     = "${data.aws_acm_certificate.cert.arn}"
	domain_name         = "coffee-api.gamesmith.co.uk"
}

resource "aws_route53_record" "coffee-api" {
	name    = "${aws_api_gateway_domain_name.coffee.domain_name}"
	type	  = "A"
	zone_id = "${aws_route53_zone.main.id}"
	alias {
		evaluate_target_health = true
		name                   = "${aws_api_gateway_domain_name.coffee.cloudfront_domain_name}"
		zone_id                = "${aws_api_gateway_domain_name.coffee.cloudfront_zone_id}"

	}
}
