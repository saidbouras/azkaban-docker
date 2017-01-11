# Azkaban

Azkaban is a batch workflow job scheduler created at LinkedIn to run Hadoop jobs.
Azkaban resolves the ordering through job dependencies and provides an easy
to use web user interface to maintain and track your workflows.

Azkaban use three components:
- AzkabanWebServer is the main manager to all of Azkaban.
It handles project management, authentication, scheduler,
and monitoring of executions. It also serves as the web user interface.
- AzkabanExecutorServer which execute the task sent and developed int the web server.
- [mysql] to store much of its state.

See [s6-overlay] wiki and [azkaban] github repository for more explanations.

You must have docker-compose installed in your machine.

## Usage

```sh
docker-compose up -d
```

If you want to use ssl connection, expose the volume in the ```docker-compose.yml```
at azkaban-web-server section :
```sh
 azkweb:
      build: ./azkaban-webserver
      image: rinscy/azkaban-webserver:3.1.0
      environment:
        - MYSQL_HOST=mysql
        - MYSQL_ROOT_PASSWORD=password
        - USE_SSL=TRUE
      ports:
        - "8081:8081"
      volumes:
        - location_of_your_keystore_file/azkaban-keystore:/opt/azkaban-webserver/azkaban-keystore
```
Look the ```azkaban.properties``` file and change the jetty configuration with the informations
 that you gave when creating your keystore file.

## Note
All [Azkaban] server docker images is tagged by azkaban version number.
Example : ```rinscy/azkaban-webserver:3.1.0 ```, use azkaban in version 3.1.0.
Note that it's the azkaban-web-server which create the azkaban database with the
azkaban admin user and the according tables.

[s6-overlay]: <https://github.com/just-containers/s6-overlay/wiki>
[azkaban]: <https://azkaban.github.io>
[mysql]: <https://hub.docker.com/_/mysql>