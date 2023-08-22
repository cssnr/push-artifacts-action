FROM ubuntu

COPY --chmod=0755 docker-entrypoint.sh /

ENTRYPOINT ["docker-entrypoint.sh"]
