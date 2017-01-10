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


## Note
   All [Azkaban] server docker images is tagged by azkaban version number.
   Example : rinscy/azkaban-webserver:3.1.0 use azkaban in version 3.1.0

   Note that it's the azkaban-web-server which create the azkaban database with the
   azkaban admin user and the according tables.
   I recommend the use of docker-compose (see in[github]repo)
   if you want a complete azkaban setup with one executor.

[s6-overlay]: <https://github.com/just-containers/s6-overlay/wiki>
[azkaban]: <https://azkaban.github.io>
[mysql]: <https://hub.docker.com/_/mysql>