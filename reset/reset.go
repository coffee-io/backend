package main

import (
    "github.com/aws/aws-lambda-go/lambda"
)

func reset() (string, error) {
    return "Reset completed.", nil
}

func main() {
    lambda.Start(reset)
}

// vim:st=4:sts=4:sw=4:expandtab
