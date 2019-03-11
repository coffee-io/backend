import boto3
import json
import traceback

def verify_cart(cart):
    pass  # TODO - go the verification service to check for values

def save_order(cart):
    pass  # TODO - save order on dynamodb

def main_handler(cart, context):
    try:
        cart = json.loads(event['body'])
        verify_cart(cart)
        save_order(cart)
        return {
            'statusCode': 201, # created
        }
    except Exception as e:
        return {
            'statusCode': 400,
            'body': ''.join(traceback.format_exception(etype=type(e), value=e, tb=e.__traceback__))
        }

# vim:st=4:sts=4:sw=4:expandtab
