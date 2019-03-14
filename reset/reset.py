import boto3
import json
from decimal import Decimal

def update_ingredients(dynamodb):
    config = dynamodb.Table('CoffeeConfig')
    config.put_item(Item={
        'configKey': 'ingredients',
        'configValue': [
            { 'name':'Espresso',        'type':'Coffee',     'color':'#000000', 'cost':Decimal(4.0) },
            { 'name':'Brewed (strong)', 'type':'Coffee',     'color':'#610B0B', 'cost':Decimal(3.0) },
            { 'name':'Brewed (weak)',   'type':'Coffee',     'color':'#8A4B08', 'cost':Decimal(3.0) },
            { 'name':'Cream',           'type':'Dairy',      'color':'#F5F6CE', 'cost':Decimal(4.0), 'lightColor': True },
            { 'name':'Milk',            'type':'Dairy',      'color':'#FAFAFA', 'cost':Decimal(2.0), 'lightColor': True },
            { 'name':'Whipped milk',    'type':'Dairy',      'color':'#F2F2F2', 'cost':Decimal(3.5), 'lightColor': True },
            { 'name':'Water',           'type':'Liquids',    'color':'#20A0FF', 'cost':Decimal(0.0), 'lightColor': True },
            { 'name':'Chocolate',       'type':'Liquids',    'color':'#8A4B08', 'cost':Decimal(5.0) },
            { 'name':'Whisky',          'type':'Liquids',    'color':'#FFBF00', 'cost':Decimal(12.0), 'lightColor': True },
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
            { 'name': 'Espresso', 'percentage': Decimal(1.0), 'type':'coffee', 'color':'#000000', 'cost':Decimal(4.0), 'qtd': 4 },
        ],
        'totalCost': Decimal(4.0),
    })
    recipes.put_item(Item={
        'userScope': 'global',
        'recipeName': 'Café con leche',
        'description': 'The perfect way to start your morning.',
        'size': 'medium',
        'ingredients': [
            { 'name': 'Brewed (strong)', 'percentage': Decimal(0.5), 'type':'coffee', 'color':'#610B0B', 'cost':Decimal(3.0), 'qtd': 2 },
            { 'name': 'Milk', 'percentage': Decimal(0.5), 'type':'liquid', 'color':'#FAFAFA', 'cost':Decimal(2.0), 'qtd': 2 },
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
