import boto3
import json
from decimal import *

def update_ingredients(config):
    response = config.put_item(Item={
        'key': 'ingredients',
        'ingredients': [
            { 'name':'Espresso', 'type':'liquid', 'color':'#141210', 'cost':Decimal(4.0) },
        ]
    })
    print('Ingredients updated.')

def main_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    config = dynamodb.Table('CoffeeConfig')
    print('Connected to AWS service')

    update_ingredients(config)

    return {
        'statusCode': 200,
        'body': json.dumps('Reset succeeded.')
    }

if __name__ == '__main__':
    main_handler(None, None)

# vim:st=4:sts=4:sw=4:expandtab
