#!/usr/bin/with-contenv /bin/bash


if [ ! -z "$(ls -A /opt/azkaban-web-server-${AZKABAN_VERSION}/conf)" ]; then
    echo " --> Do nothing, we want to persist files !"
else
    if [ "$USE_SSL" == "TRUE" ] || [ "$USE_SSL" == "true" ]; then
        echo " ---> Active ssl on azkaban"
        sed -i 's/jetty.use.ssl=false/jetty.use.ssl=true/g' /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
        sed -i 's/#jetty.ssl.port/jetty.ssl.port/g' /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
        sed -i 's/#jetty.keystore/jetty.keystore/g' /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
        sed -i 's/#jetty.password/jetty.password//g' /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
        sed -i 's/#jetty.keypassword/jetty.keypassword/g' /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
        sed -i 's/#jetty.truststore/jetty.truststore/g' /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
        sed -i 's/#jetty.trustpassword/jetty.trustpassword/g' /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
    fi

    echo " --> Setup azkaban conf directory"
    cp /root/azkaban-keystore /opt/azkaban-web-server-${AZKABAN_VERSION}/
    cp /root/azkaban.properties /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/
    cp /root/azkaban-users.xml /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/

    cp /mysql-connector-java-*/mysql-connector-java-*-bin.jar /opt/azkaban-web-server-${AZKABAN_VERSION}/extlib/

    sed -i "s/&//" /opt/azkaban-web-server-${AZKABAN_VERSION}/bin/azkaban-web-start.sh
    sed -i "s/&//" /opt/azkaban-web-server-${AZKABAN_VERSION}/bin/start-web.sh

    echo " --> Replace environments vars "
    sed -i "s@%MYSQL_HOST%@${MYSQL_HOST:-"mysql"}@g"  /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
    sed -i "s@%AZKABAN_EXECUTOR%@${AZKABAN_EXECUTOR:-"azkexec"}@g"  /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties

    sed -i "s@%AZKABAN_USER%@${AZKABAN_USER:-"azkaban"}@g" /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
    sed -i "s@%AZKABAN_USER%@${AZKABAN_USER:-"azkaban"}@g" /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban-users.xml
    sed -i "s@%AZKABAN_PASSWORD%@${AZKABAN_PASSWORD:-"azkaban"}@g" /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban.properties
    sed -i "s@%AZKABAN_PASSWORD%@${AZKABAN_PASSWORD:-"azkaban"}@g" /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/azkaban-users.xml

    sed -i "s@%AZKABAN_USER%@${AZKABAN_USER:-"azkaban"}@g" /etc/services.d/azkaban-webserver/run

    echo " --> Create unix user for azkaban"
    [ -z $AZKABAN_USER ] && AZKABAN_USER=azkaban && AZKABAN_PASSWORD=azkaban

    useradd -ms /bin/bash ${AZKABAN_USER}
    chown -R ${AZKABAN_USER}:${AZKABAN_USER} /opt/azkaban-web-server-${AZKABAN_VERSION}
    chmod 755 /opt/azkaban-web-server-${AZKABAN_VERSION}/conf/*
fi

exit 0
