FROM alpine:latest

RUN apk add --update --no-cache bash curl jq openssh rsync sshpass

COPY --chmod=0755 entrypoint.sh /
COPY --chmod=0755 scripts/ /scripts

ENTRYPOINT ["/entrypoint.sh"]
