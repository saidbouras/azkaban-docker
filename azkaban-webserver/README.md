# Azkaban-web-server

A simple container running azkaban-web-server with s6-overlay supervisor.

See [s6-overlay] wiki and [Azkaban] github repository for more explanations.


## Usage

To start azkaban-web-server, launch a ```docker run ```  command with the rights properties.
Note that there is mysql-client inside which use a tcp connection to a mysql instance.
You need to either link the azkaban-web-server container to a mysql container (see [mysql] container usage),
or specify the rights docker network properties.


- If you have already a [mysql] container started :

```sh
docker run --name azkwebserver -dt \
    -e MYSQL_ROOT_PASSWORD=\
    -e MYSQL_HOST=mysql_container_name\
    -v path_to_your_conf_directory:/opt/azkaban-web-server/conf \
    -v path_to_your_extlib_directory:/opt/azkaban-web-server/extlib \
    -p 8081:8081 \
    --link mysql_container_name:mysql \
    rinscy/azkaban-webserver:3.1.0
```

- If you have want to use a keystore add USE_SSL variable environment (default set to false) :

```sh
docker run --name azkwebserver -dt \
    -e MYSQL_ROOT_PASSWORD=\
    -e MYSQL_HOST=mysql_container_name\
    -e USE_SSL=TRUE
    -v path_to_your_conf_directory:/opt/azkaban-web-server/conf \
    -v path_to_your_extlib_directory:/opt/azkaban-web-server/extlib \
    -p 8081:8081 \
    --link mysql_container_name:mysql \
    rinscy/azkaban-webserver:3.1.0
```

## Note
All [Azkaban] server docker images is tagged by azkaban version.
Example : ```rinscy/azkaban-webserver:3.1.0 ```, use azkaban in version 3.1.0.

Note that it's the azkaban-web-server which create the azkaban database with the
azkaban admin user and the according tables.
I recommend the use of docker-compose (see in [github] repo) if you want a complete azkaban setup with one executor.


[s6-overlay]: <https://github.com/just-containers/s6-overlay/wiki>
[Azkaban]: <https://azkaban.github.io>
[mysql]: <https://hub.docker.com/_/mysql>
[github]: <https://github.com/rinscy>