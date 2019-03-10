import math
import json

def get_ingredients():
    pass

def check_cart_integrity(cart):
    pass

def recalculate_values(cart, ingredients):
    total = 0.0
    for item in cart['items']:
        cup_cost = 0.0
        for ing in item['ingredients']:
            cup_cost += ingredients[ing['name']]['cost'] / 4.0 * ing['qtd']
        item['totalCost'] = math.floor(cpu_cost * 2) / 2;
        total += item['totalCost']
    cart['total'] = total

def main_handler(cart, context):
    try:
        ingredients = get_ingredients()
        check_cart_integrity(cart)
        recalculate_ingredients(cart, ingredients)
        return {
            'statusCode': 200,
            'body': json.dumps(cart)
        }
    except Exception as e:
        return {
            'statusCode': 400,
            'body': str(e)
        }

# vim:st=4:sts=4:sw=4:expandtab
