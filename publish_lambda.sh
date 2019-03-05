#!/bin/sh

cd $1
zip $1.zip *
aws s3 cp ./$1.zip s3://coffee-artifacts/
aws lambda update-function-code --function-name main_handler --s3-bucket coffee-artifacts --s3-key $1.zip --publish