import json

def main_handler(event, context):
    print('Event: ', event)
    print('Context: ', context)
    return {
        'statusCode': 200,
        'body': json.dumps({ 'value': 'python' })
    }

# vim:st=4:sts=4:sw=4:expandtab
