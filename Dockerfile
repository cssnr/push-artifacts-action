FROM python:3.11-alpine

RUN apk add --update --no-cache bash curl jq openssh rsync sshpass
COPY requirements.txt requirements.txt
RUN python -m pip install -r requirements.txt

COPY --chmod=0755 entrypoint.sh /
COPY --chmod=0755 templates/ /templates
COPY --chmod=0755 scripts/ /scripts

ENTRYPOINT ["/entrypoint.sh"]
