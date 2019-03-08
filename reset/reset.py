import boto3
import json
from decimal import Decimal

def update_ingredients(dynamodb):
    config = dynamodb.Table('CoffeeConfig')
    config.put_item(Item={
        'configKey': 'ingredients',
        'configValue': [
            { 'name':'Espresso',        'type':'coffee', 'color':'#000000', 'cost':Decimal(4.0) },
            { 'name':'Brewed (strong)', 'type':'coffee', 'color':'#610B0B', 'cost':Decimal(3.0) },
            { 'name':'Brewed (weak)',   'type':'coffee', 'color':'#8A4B08', 'cost':Decimal(3.0) },
            { 'name':'Water',           'type':'liquid', 'color':'#0080FF', 'cost':Decimal(0.0) },
            { 'name':'Cream',           'type':'liquid', 'color':'#F5F6CE', 'cost':Decimal(4.0), 'lightColor': True },
            { 'name':'Milk',            'type':'liquid', 'color':'#FAFAFA', 'cost':Decimal(2.0), 'lightColor': True },
            { 'name':'Whipped milk',    'type':'liquid', 'color':'#F2F2F2', 'cost':Decimal(3.5), 'lightColor': True },
            { 'name':'Chocolate',       'type':'liquid', 'color':'#8A4B08', 'cost':Decimal(5.0) },
            { 'name':'Whisky',          'type':'liquid', 'color':'#FFBF00', 'cost':Decimal(12.0) },
            { 'name':'Sugar',           'type':'added',  'color':'#FAFAFA', 'cost':Decimal(0.0) },
            { 'name':'Cinnamon',        'type':'added',  'color':'#5F4C0B', 'cost':Decimal(0.0) },
            { 'name':'Nutmeg',          'type':'added',  'color':'#DBA901', 'cost':Decimal(0.0) },
            { 'name':'Sucralose',       'type':'added',  'color':'#E0E6F8', 'cost':Decimal(0.0) },
        ]
    })
    print('Ingredients updated.')

def update_recipes(dynamodb):
    recipes = dynamodb.Table('CoffeeRecipes')
    recipes.put_item(Item={
        'userScope': 'global',
        'recipeName':  'Espresso',
        'description': 'A creamy, strong coffee prepared under ideal conditions.',
        'size':  'small',
        'ingredients': [
            { 'name': 'Espresso', 'percentage': Decimal(1.0), 'type':'coffee', 'color':'#000000', 'cost':Decimal(4.0) },
        ],
        'totalCost': Decimal(4.0),
    })
    recipes.put_item(Item={
        'userScope': 'global',
        'recipeName': 'Café con leche',
        'description': 'The perfect way to start your morning.',
        'size': 'medium',
        'ingredients': [
            { 'name': 'Brewed (string)', 'percentage': Decimal(0.5), 'type':'coffee', 'color':'#610B0B', 'cost':Decimal(3.0) },
            { 'name': 'Milk', 'percentage': Decimal(0.5), 'type':'liquid', 'color':'#FAFAFA', 'cost':Decimal(2.0) },
        ],
        'totalCost': Decimal(5.0),
    })
    print('Recipes updated.')

def main_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    print('Connected to AWS service')

    update_ingredients(dynamodb)
    update_recipes(dynamodb)

    return {
        'statusCode': 200,
        'body': json.dumps('Reset succeeded.')
    }

if __name__ == '__main__':
    main_handler(None, None)

# vim:st=4:sts=4:sw=4:expandtab
