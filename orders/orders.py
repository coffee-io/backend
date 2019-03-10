import json

def main_handler(cart, context):
    check_cart(cart)


    ingredients = get_db_data()
    


    print('Event: ', event)
    print('Context: ', context)
    return {
        'statusCode': 200,
        'body': json.dumps({ 'value': 'python' })
    }

# vim:st=4:sts=4:sw=4:expandtab
