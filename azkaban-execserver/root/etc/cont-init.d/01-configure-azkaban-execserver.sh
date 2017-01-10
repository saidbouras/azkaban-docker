#!/usr/bin/with-contenv /bin/sh


if [ ! -z "$(ls -A /opt/azkaban-exec-server-${AZKABAN_VERSION}/conf)" ]; then
    echo " --> Do nothing, we want to persist files !"

else
    echo " --> Set azkaban conf directory"
    cp /root/azkaban.properties /opt/azkaban-exec-server-${AZKABAN_VERSION}/conf/
    cp /mysql-connector-java-*/mysql-connector-java-*-bin.jar /opt/azkaban-exec-server-${AZKABAN_VERSION}/extlib/

    echo " --> Replace environments vars "
    sed -i "s/&//" /opt/azkaban-exec-server-${AZKABAN_VERSION}/bin/azkaban-executor-start.sh
    sed -i "s/&//" /opt/azkaban-exec-server-${AZKABAN_VERSION}/bin/start-exec.sh
    sed -i "s@%MYSQL_HOST%@${MYSQL_HOST:-"mysql"}@g" /opt/azkaban-exec-server-${AZKABAN_VERSION}/conf/azkaban.properties
    sed -i "s@%AZKABAN_USER%@${AZKABAN_USER:-"azkaban"}@g" /opt/azkaban-exec-server-${AZKABAN_VERSION}/conf/azkaban.properties
    sed -i "s@%AZKABAN_PASSWORD%@${AZKABAN_PASSWORD:-"azkaban"}@g" /opt/azkaban-exec-server-${AZKABAN_VERSION}/conf/azkaban.properties

    sed -i "s@%AZKABAN_USER%@${AZKABAN_USER:-"azkaban"}@g" /etc/services.d/azkaban-execserver/run

    if [ -z $AZKABAN_USER ]; then
        AZKABAN_USER=azkaban
    fi
    useradd -ms /bin/bash ${AZKABAN_USER}
    chown -R ${AZKABAN_USER}:${AZKABAN_USER} /opt/azkaban-exec-server-${AZKABAN_VERSION}

fi

exit 0
