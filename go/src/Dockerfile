#FROM golang:onbuild
FROM golang:latest

ADD . /go/src
WORKDIR /go/src/
RUN cd $(ls -d */) && \
    pwd && \
    go build -o main .

CMD ["/go/src/Cloudground/main"]

EXPOSE 8090
