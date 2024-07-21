FROM python:3.11-alpine

RUN apk add --update --no-cache bash curl github-cli jq openssh rsync sshpass
COPY requirements.txt /requirements.txt
RUN python -m pip install -r /requirements.txt

COPY entrypoint.sh /
COPY templates/ /templates
COPY scripts/ /scripts

ENTRYPOINT ["bash", "/entrypoint.sh"]
