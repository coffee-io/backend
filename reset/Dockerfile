FROM gobuild-lambda

WORKDIR /go/src/app
COPY . .

CMD go build -v -ldflags="-s -w" -o reset . && zip reset.zip reset && aws s3 cp ./reset.zip s3://coffee-artifacts/
