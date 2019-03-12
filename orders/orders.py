import boto3
import decimal
import json
import math
import traceback
import uuid
import sys
from botocore.exceptions import ClientError
from botocore.vendored import requests
from boto3.dynamodb.conditions import Key, Attr
from datetime import datetime
from decimal import Decimal

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

def save_order(cart):
    dynamodb = boto3.resource('dynamodb')
    recipes = dynamodb.Table('CoffeeOrders')
    recipes.put_item(Item={ 
        **{
            'id': str(uuid.uuid4()),
            'orderDate': datetime.now().isoformat(),
        },
        **cart
    })

def send_email(cart):
    client = boto3.client('ses')
    try:
        response = client.send_email(
            Source='andre.nho@gmail.com',
            Destination={
                'ToAddresses': [ cart['deliveryAddress']['email'] ],
            },
            Message={
                'Body': {
                    'Text': {
                        'Charset': 'UTF-8',
                        'Text': text,
                    },
                },
            },
        )
    except ClientError as e:
        raise Exception(e.response['Error']['Message'])
    else:
        print('E-mail sent.')

def main_handler(event, context):
    print(event)
    try:
        cart = json.loads(event['body'], parse_float = decimal.Decimal)
        ingredients = get_ingredients()
        check_cart_integrity(cart)
        recalculate_values(cart, ingredients)
        if event['resource'] == '/cart' and event['httpMethod'] == 'POST':
            save_order(cart)
            send_email(cart)
            return { 'statusCode': 201, } # created
        elif event['resource'] == '/cart/calculator' and event['httpMethod'] == 'PUT':
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
    print(main_handler({ 'body': json.dumps(data, cls=DecimalEncoder, ensure_ascii=False) }, None))

# vim:st=4:sts=4:sw=4:expandtab