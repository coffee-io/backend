variable "name"            {}
variable "lambda_role_arn" {}
variable "runtime"         { default = "go1.x" } 
variable "memory_size"     { default = 128 }
variable "retention"       { default = 7 }

# 
# lambda
#

resource "aws_lambda_function" "lambda" {
  function_name    = "${var.name}"
  role             = "${var.lambda_role_arn}"
	handler          = "${var.name}.main_handler"
  runtime          = "${var.runtime}"
	memory_size			 = "${var.memory_size}"
	s3_bucket        = "coffee-artifacts"
	s3_key           = "${var.name}.zip"
}

resource "null_resource" "update_lambda" {
	depends_on = ["aws_lambda_function.lambda"]
	provisioner "local-exec" {
		command = "aws lambda update-function-code --function-name ${var.name} --s3-bucket coffee-artifacts --s3-key ${var.name}.zip --publish"
	}
	triggers {
		build_number = "${timestamp()}" 
	}
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = "${var.retention}"
}

output "lambda_arn" {
	value = "${aws_lambda_function.lambda.arn}"
}
