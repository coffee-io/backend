resource "aws_dynamodb_table" "coffee_data" {
	name					= "CoffeeData"
	billing_mode	= "PAY_PER_REQUEST"
	hash_key      = "Key"

	attribute {
		name = "Key"
		type = "S"
	}
}
