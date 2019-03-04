package main

import (
    "log"
    "os"

    "github.com/aws/aws-lambda-go/events"
    "github.com/aws/aws-lambda-go/lambda"
)

var errorLogger = log.New(os.Stderr, "ERROR ", log.Llongfile)

func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
    log.Println(request);
    return events.APIGatewayProxyResponse{
        StatusCode: 200,
    }, nil
}

func main() {
    lambda.Start(Handler)
}

// vim:st=4:sts=4:sw=4:expandtab
