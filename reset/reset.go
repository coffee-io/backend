package main

import (
    "fmt"
    "log"
    "os"

    "github.com/aws/aws-lambda-go/lambda"
    "github.com/aws/aws-sdk-go/aws"
    "github.com/aws/aws-sdk-go/aws/session"
    "github.com/aws/aws-sdk-go/service/dynamodb"
    "github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

var errorLog = log.New(os.Stderr, "ERROR ", log.Llongfile)

func reset() (string, error) {
    log.Println("Will now reset the database.")

    // connect to dynamodb
    session := session.Must(session.NewSession(&aws.Config{}))
    svc := dynamodb.New(session)
    log.Println("Connected to dynamodb.")

    // Ingredients
    type ingredient struct {
        Name    string  `json:"name"`
        Type    string  `json:"type"`
        Color   string  `json:"color"`
        Cost    float32 `json:"cost"`
    }

    type ingredients struct {
        Key             string       `json:"key"`
        Ingredient_list []ingredient `json:"ingredients"`
    }

    my_ingredients := ingredients{
        Key: "ingredients",
        Ingredient_list: []ingredient{
            ingredient{ Name: "Espresso", Type: "liquid", Color: "#141210", Cost: 4.0 },
        },
    }

    av, err := dynamodbattribute.MarshalMap(my_ingredients)
    input := &dynamodb.PutItemInput{
        Item: av,
        TableName: aws.String("CoffeeConfig"),
    }
    _, err = svc.PutItem(input)

    if err != nil {
        s := fmt.Sprintln(err.Error())
        errorLog.Println(s)
        return s, err
    }

    return "Reset completed.", nil
}

func main() {
    lambda.Start(reset)
}

// vim:st=4:sts=4:sw=4:expandtab
