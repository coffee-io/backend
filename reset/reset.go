package main

import (
    "log"
    "os"
)

var errorLogger = log.New(os.Stderr, "ERROR ", log.Llongfile)

func main() {
    errorLogger.Println("Reset!");
}

// vim:st=4:sts=4:sw=4:expandtab
