resource "aws_dynamodb_table" "coffee_data" {
	name					= "CoffeeConfig"
	billing_mode	= "PAY_PER_REQUEST"
	hash_key      = "key"

	attribute {
		name = "Key"
		type = "S"
	}
}
