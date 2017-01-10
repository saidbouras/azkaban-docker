#!/usr/bin/with-contenv /bin/sh

# set azkaban database
sed -i "s@%AZKABAN_USER%@${AZKABAN_USER:-"azkaban"}@g" /root/azkaban-setup.sql
sed -i "s@%AZKABAN_PASSWORD%@${AZKABAN_PASSWORD:-"azkaban"}@g" /root/azkaban-setup.sql

#unzip /azkaban/azkaban-sql/build/distributions/azkaban-sql-${AZKABAN_VERSION}.zip -d /opt
unzip /azkaban/build/distributions/azkaban-sql-${AZKABAN_VERSION}.zip -d /opt

ttw=1
while ! nc $MYSQL_HOST 3306 </dev/null >/dev/null 2>&1; do
    i=$(($i+1));
    if [ $i -ge 30 ]; then
        ttw=10;
    fi
    if [ $i -ge 60 ]; then
        echo "$MYSQL_HOST:3306 not reachable, abort";
        exit 1;
    fi
    echo "$i) waiting for $MYSQL_HOST:3306";
    sleep $ttw;
done

mysql -h $MYSQL_HOST -P 3306 -p${MYSQL_ROOT_PASSWORD} < /root/azkaban-setup.sql \
&& mysql -h $MYSQL_HOST -P 3306 -p${MYSQL_ROOT_PASSWORD} azkaban < /opt/azkaban-sql-${AZKABAN_VERSION}/create-all-sql-${AZKABAN_VERSION}.sql &&
cat /opt/azkaban-sql-${AZKABAN_VERSION}/update.*.sql | mysql -h $MYSQL_HOST -P 3306 -p${MYSQL_ROOT_PASSWORD} azkaban

exit 0
