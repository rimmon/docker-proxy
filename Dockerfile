FROM alpine:3.14

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

ENV USER=proxy
ENV UID=1000
ENV GID=1000
RUN addgroup --gid $GID $USER
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

RUN mkdir $SQUID_CACHE_DIR $SQUID_LOG_DIR
RUN chown $USER:$USER $SQUID_CACHE_DIR $SQUID_LOG_DIR
RUN chmod 777 $SQUID_CACHE_DIR $SQUID_LOG_DIR

RUN apk --update add \
    bash \
    squid \
    && rm -rf /var/cache/apk/*

ADD squid.conf /etc/squid/squid.conf
ADD entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh

EXPOSE 3128/tcp
ENTRYPOINT ["/entrypoint.sh"]
