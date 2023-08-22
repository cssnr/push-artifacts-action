FROM ubuntu

COPY --chmod=0755 entrypoint.sh /
COPY --chmod=0755 scripts/ /scripts

ENTRYPOINT ["/entrypoint.sh"]
