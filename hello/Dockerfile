FROM gobuild-lambda

WORKDIR /go/src/app
COPY . .

CMD go build -v -ldflags="-s -w" -o hello . && zip hello.zip hello && aws s3 cp ./hello.zip s3://coffee-artifacts/
