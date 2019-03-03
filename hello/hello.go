package main

import (
    "encoding/json"
    "github.com/aws/aws-lambda-go/events"
    "github.com/aws/aws-lambda-go/lambda"
    "net/http"
)

type Request struct {}

type Response struct {
    Value string `json:"value"`
}

func clientError(status int) (events.APIGatewayProxyResponse, error) {
    return events.APIGatewayProxyResponse{
        StatusCode: status,
        Body:       http.StatusText(status),
    }, nil
}

func serverError(err error) (events.APIGatewayProxyResponse, error) {
    // errorLogger.Println(err.Error())

    return events.APIGatewayProxyResponse{
        StatusCode: http.StatusInternalServerError,
        Body:       http.StatusText(http.StatusInternalServerError),
    }, nil
}

func get(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
    js, err := json.Marshal(Response { Value: "world" })
    if err != nil {
        return serverError(err)
    }
    return events.APIGatewayProxyResponse{
        StatusCode: http.StatusOK,
        Body:       string(js),
    }, nil
}

func router(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
    if req.HTTPMethod == "GET" {
        return get(req)
    } else {
        return clientError(http.StatusMethodNotAllowed)
    }
}

func main() {
    lambda.Start(router);
}

// vim:st=4:sts=4:sw=4:expandtab
