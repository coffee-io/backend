import boto3
import decimal
import math
import traceback
import json
import sys
from decimal import Decimal
from boto3.dynamodb.conditions import Key, Attr

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if o % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

def get_ingredients():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('CoffeeConfig')
    response = table.query(
        KeyConditionExpression=Key('configKey').eq('ingredients')
    )
    r = {}
    for ing in response['Items'][0]['configValue']:
        r[ing['name']] = ing
    return r

def check_cart_integrity(cart):
    if not 'items' in cart:
        raise Exception('"items" is missing.')
    if len(cart['items']) == 0:
        raise Exception('No items in cart.')
    for item in cart['items']:
        if not 'ingredients' in item:
            raise Exception('"ingredients" is missing.')
        if len(item['ingredients']) == 0:
            raise Exception('No ingredients in item.')

def recalculate_values(cart, ingredients):
    total = Decimal(0.0)
    for item in cart['items']:
        cup_cost = Decimal(0.0)
        for ing in item['ingredients']:
            cup_cost += ingredients[ing['name']]['cost'] / Decimal(4.0) * ing['qtd']
        item['totalCost'] = Decimal(math.floor(cup_cost * 2) / 2)
        total += item['totalCost']
    cart['total'] = total

def main_handler(event, context):
    cart = json.loads(event['body'])
    return { 'statusCode': 200, 'event': cart }
    try:
        ingredients = get_ingredients()
        check_cart_integrity(cart)
        recalculate_values(cart, ingredients)
        return {
            'statusCode': 200,
            'body': json.dumps(cart, cls=DecimalEncoder, ensure_ascii=False)
        }
    except Exception as e:
        return {
            'statusCode': 400,
            'body': ''.join(traceback.format_exception(etype=type(e), value=e, tb=e.__traceback__))
        }

if __name__ == '__main__':
    cart = {}
    with open("test.json") as json_file:
        data = json.load(json_file, parse_float = decimal.Decimal)
    print(main_handler(data, None))

# vim:st=4:sts=4:sw=4:expandtab
