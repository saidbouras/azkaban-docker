 Azkaban-exec-server

A simple container running azkaban-exec-server with s6-overlay supervisor.

See [s6-overlay] wiki and [azkaban] github repository for more explanations.


## Usage
To start azkaban-exec-server, launch a ```docker run ```  command with the rights properties.
Note that there is a mysql-client inside which use a tcp connection to a mysql instance.
You need to either link the azkaban-exec-server container to a mysql container (see [mysql] container usage),
or specify the rights docker network properties.


- If you have already a [mysql] container started :

```sh
docker run --name azkwebserver -dt \
    -e MYSQL_HOST=mysql_container_name\
    -v path_to_your_conf_directory:/opt/azkaban-exec-server/conf \
    -p 12321:12321 \
    --link mysql_container_name
    --link azkaban-web-server_container\
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