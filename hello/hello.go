package main

import (
    "github.com/aws/aws-lambda-go/lambda"
)

type Request struct {}

type Response struct {
    Value string `json:"value"`
}

func Handler(request Request) (Response, error) {
    return Response { Value: "world" }, nil
}

func main() {
    lambda.Start(Handler);
}

// vim:st=4:sts=4:sw=4:expandtab
