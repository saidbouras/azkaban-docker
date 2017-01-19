FROM debian:jessie
MAINTAINER Saïd Bouras <said.bouras@gmail.com>

ENV \
    DEBIAN_FRONTEND=noninteractive \
    S6_OVERLAY_VERSION=1.18.1.5 \
    MYSQL_JDBC_VERSION=5.1.40 \
    AZKABAN_VERSION=3.1.0

RUN set -x \
    # Install packages
    && echo "deb http://ftp.de.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && BUILD_DEPS="curl git" \
    && apt-get install -y --no-install-recommends \
           netcat \
           $BUILD_DEPS \
           ca-certificates \
           unzip \
           mysql-client \
           openjdk-8-jdk

RUN git clone https://github.com/azkaban/azkaban.git && cd azkaban \
    && git checkout tags/$AZKABAN_VERSION \
    && ./gradlew distZip

RUN unzip /azkaban/build/distributions/azkaban-exec-server-${AZKABAN_VERSION}.zip -d /opt \
    && ln -s /opt/azkaban-exec-server-${AZKABAN_VERSION} /opt/azkaban-exec-server \
    && mkdir -p /opt/azkaban-exec-server-${AZKABAN_VERSION}/conf /opt/azkaban-exec-server-${AZKABAN_VERSION}/extlib \
    && curl -sLk http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_JDBC_VERSION.tar.gz | tar xz

RUN rm -rf /opt/azkaban-exec-server/conf/*

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

    # Clean
RUN apt-get remove -y --purge \
           $BUILD_DEPS \
    && apt-get autoremove -y --purge \
    && find . -type d -name ".git" | xargs rm -rf \
    && rm -rf \
           /tmp/* \
           /usr/local/lib/* \
           /var/lib/apt/lists/* \
           /var/www/.git \
           /var/tmp/* \
           /usr/share/man \
           /usr/share/doc \
           /usr/share/doc-base \
           /var/www/html

COPY ./root/etc /etc/
COPY ./root/azkaban.properties /root/azkaban.properties

EXPOSE 12321

WORKDIR /opt/azkaban-exec-server-${AZKABAN_VERSION}

ENTRYPOINT [ "/init" ]
