#!/bin/sh

cd $1 \
	&& aws lambda update-function-code --function-name $1 --s3-bucket coffee-artifacts --s3-key $1.zip --publish \
	&& cd ..
