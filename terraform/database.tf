resource "aws_dynamodb_table" "coffee_data" {
  name           = "CoffeeConfig"
  read_capacity  = 1
  write_capacity = 1
  billing_mode   = "PROVISIONED"
  hash_key       = "configKey"

  attribute {
    name = "configKey"
    type = "S"
  }
}

resource "aws_dynamodb_table" "recipes" {
  name           = "CoffeeRecipes"
  read_capacity  = 1
  write_capacity = 1
  billing_mode   = "PROVISIONED"
  hash_key       = "userScope"
  range_key      = "recipeName"

  attribute {
    name = "userScope"
    type = "S"
  }

  attribute {
    name = "recipeName"
    type = "S"
  }
}

resource "aws_dynamodb_table" "orders" {
  name           = "CoffeeOrders"
  read_capacity  = 1
  write_capacity = 1
  billing_mode   = "PROVISIONED"
  hash_key       = "id"
  range_key      = "orderDate"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "orderDate"
    type = "S"
  }
}
