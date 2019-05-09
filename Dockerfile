FROM alpine
ENV TZ Asia/Shanghai
# Make port 8080 available to the world outside this container
EXPOSE 8080
RUN apk --no-cache add git musl-dev krb5-dev openssl-dev tzdata openssl alpine-conf krb5 gcc make imagemagick-libs imagemagick ghostscript ghostscript-gtk ghostscript-dev  ghostscript-fonts && \
    git clone https://bitbucket.org/ritt/elog --recursive && \
    cd /elog && \
    make -j8 USE_SSL=1 USE_KRB5=1 && \
    make install && \
    addgroup -S elog && \
    adduser -S -u 100 -G elog elog && \
    cd / && \
    rm -rf /usr/local/elog /elog && \
    mkdir -p /var/run/ && \
    rm -rf /usr/share/man/ && \
    rm -rf /usr/share/locale/ && \
    setup-timezone -z ${TZ} && \
    cp -r -f /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" >  /etc/timezone && \
    date && \
    apk del git gcc make apk-tools musl-dev krb5-dev openssl-dev alpine-conf  
ENTRYPOINT ["elogd"]
CMD ["-x","-p","8080","-c","/home/elog/elogd.cfg","-d","/home/elog/logbooks","-s","/home/elog/resources"]
