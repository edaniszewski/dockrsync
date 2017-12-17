FROM alpine:latest
RUN apk --update --no-cache add rsync openssh

WORKDIR /dockrsync
COPY sync.sh .

CMD ["./sync.sh"]
