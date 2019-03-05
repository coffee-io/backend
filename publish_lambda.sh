#!/bin/sh

cd $1 \
	&& zip $1.zip * \
	&& aws s3 cp ./$1.zip s3://coffee-artifacts/ \
	&& cd ..
