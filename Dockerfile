FROM ubuntu

COPY --chmod=0755 entrypoint.sh /

ENTRYPOINT ["entrypoint.sh"]
