import boto3
import decimal
import json
import traceback
import sys
from botocore.vendored import requests
from datetime import datetime

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if o % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

def verify_cart(cart_json):
    url = "https://coffee-api.gamesmith.co.uk/cart/calculator"
    response = requests.put(url, data=cart_json)
    return json.loads(response)

def save_order(cart):
    dynamodb = boto3.resource('dynamodb')
    recipes = dynamodb.Table('CoffeeOrders')
    recipes.put_item(Item={ 
        **{
            'userEmail': cart['deliveryAddress']['email'],
            'orderDate': datetime.now().isoformat(),
        }, 
        **cart
    })

def main_handler(event, context):
    try:
        cart_json = event['body']
        cart = json.loads(event['body'])
        cart = verify_cart(cart_json)
        save_order(cart)
        return {
            'statusCode': 201, # created
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