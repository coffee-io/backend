package main

import (
    "context"
    "encoding/json"
    "fmt"
    "github.com/aws/aws-lambda-go/events"
    "github.com/aws/aws-lambda-go/lambda"
    "log"
    "net/http"
    "os"
    "strings"
)

var errorLogger = log.New(os.Stderr, "ERROR ", log.Llongfile)

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
    errorLogger.Println(err.Error())

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
        Headers:    map[string]string{"Access-Control-Allow-Origin": "*"},
        Body:       string(js),
    }, nil
}

func router(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
    errorLogger.Println(ctx)
    errorLogger.Println(req)
    if strings.ToUpper(req.HTTPMethod) == "GET" {
        return get(req)
    } else {
        // return clientError(http.StatusMethodNotAllowed)
        return events.APIGatewayProxyResponse{
            StatusCode: http.StatusOK,
            Body:       fmt.Sprint(req),
        }, nil
    }
}

func main() {
    lambda.Start(router);
}

// vim:st=4:sts=4:sw=4:expandtab
