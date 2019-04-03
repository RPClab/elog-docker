FROM alpine

# Make port 80 available to the world outside this container
EXPOSE 8080
RUN apk --no-cache add git musl-dev krb5-dev openssl-dev openssl krb5 gcc make imagemagick && \
    git clone https://bitbucket.org/ritt/elog --recursive && \
    cd /elog && \
    make -j8 USE_SSL=1 USE_KRB5=1 && \
    make install && \
    addgroup -S elog && \
    adduser -S -u 100 -G elog elog && \
    cd / && \
    rm -rf /usr/local/elog /elog && \
    apk del git gcc make apk-tools musl-dev krb5-dev openssl-dev && \
    mkdir -p /var/run/ && \
    sed -i "${host}  ${smtpserver}" /etc/hosts
ENTRYPOINT ["elogd"]
CMD ["-p", "8080", "-c", "/home/elog/elogd.cfg", "-d","/home/elog/logbooks","-s","/home/elog/resources"]
