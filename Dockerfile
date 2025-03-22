FROM python:3.13-alpine

RUN apk add --update --no-cache bash curl github-cli jq openssh rsync sshpass

COPY requirements.txt /requirements.txt
RUN python -m pip install -r /requirements.txt

COPY src/ /src

ENTRYPOINT ["bash", "/src/main.sh"]
