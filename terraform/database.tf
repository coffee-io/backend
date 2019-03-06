resource "aws_dynamodb_table" "coffee_data" {
	name					= "CoffeeConfig"
	billing_mode	= "PAY_PER_REQUEST"
	hash_key      = "configKey"

	attribute {
		name = "configKey"
		type = "S"
	}
}

resource "aws_dynamodb_table" "recipes" {
	name					= "CoffeeRecipes"
	billing_mode	= "PAY_PER_REQUEST"
	hash_key      = "userScope"
	range_key     = "recipeName"

	attribute {
		name = "userScope"
		type = "S"
	}

	attribute {
		name = "recipeName"
		type = "S"
	}
}
