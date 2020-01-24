
Running Kibana on Docker
edit

Docker images for Kibana are available from the Elastic Docker registry. The base image is centos:7.

A list of all published Docker images and tags is available at www.docker.elastic.co. The source code is in GitHub.

These images are free to use under the Elastic license. They contain open source and free commercial features and access to paid commercial features. Start a 30-day trial to try out all of the paid commercial features. See the Subscriptions page for information about Elastic license levels.
Pulling the image
edit

Obtaining Kibana for Docker is as simple as issuing a docker pull command against the Elastic Docker registry.

docker pull docker.elastic.co/kibana/kibana:7.5.2

Alternatively, you can download other Docker images that contain only features available under the Apache 2.0 license. To download the images, go to www.docker.elastic.co.
Running Kibana on Docker for development
edit

Kibana can be quickly started and connected to a local Elasticsearch container for development or testing use with the following command:

docker run --link YOUR_ELASTICSEARCH_CONTAINER_NAME_OR_ID:elasticsearch -p 5601:5601 {docker-repo}:{version}

Configuring Kibana on Docker
edit

The Docker images provide several methods for configuring Kibana. The conventional approach is to provide a kibana.yml file as described in Configuring Kibana, but it’s also possible to use environment variables to define settings.
Bind-mounted configuration
edit

One way to configure Kibana on Docker is to provide kibana.yml via bind-mounting. With docker-compose, the bind-mount can be specified like this:

version: '2'
services:
  kibana:
    image: docker.elastic.co/kibana/kibana:7.5.2
    volumes:
      - ./kibana.yml:/usr/share/kibana/config/kibana.yml

Environment variable configuration
edit

Under Docker, Kibana can be configured via environment variables. When the container starts, a helper process checks the environment for variables that can be mapped to Kibana command-line arguments.

For compatibility with container orchestration systems, these environment variables are written in all capitals, with underscores as word separators. The helper translates these names to valid Kibana setting names.

Some example translations are shown here:

Table 1. Example Docker Environment Variables

Environment Variable
	

Kibana Setting

SERVER_NAME
	

server.name

KIBANA_DEFAULTAPPID
	

kibana.defaultAppId

XPACK_MONITORING_ENABLED
	

xpack.monitoring.enabled

In general, any setting listed in Configuring Kibana can be configured with this technique.

These variables can be set with docker-compose like this:

version: '2'
services:
  kibana:
    image: docker.elastic.co/kibana/kibana:7.5.2
    environment:
      SERVER_NAME: kibana.example.org
      ELASTICSEARCH_HOSTS: http://elasticsearch.example.org

Since environment variables are translated to CLI arguments, they take precedence over settings configured in kibana.yml.
Docker defaults
edit

The following settings have different default values when using the Docker images:

server.name
	

kibana

server.host
	

"0"

elasticsearch.hosts
	

http://elasticsearch:9200

xpack.monitoring.ui.container.elasticsearch.enabled
	

true

The setting xpack.monitoring.ui.container.elasticsearch.enabled is not defined in the -oss image.

These settings are defined in the default kibana.yml. They can be overridden with a custom kibana.yml or via environment variables.

If replacing kibana.yml with a custom version, be sure to copy the above defaults to the custom file if you want to retain them. If not, they will be "masked" by the new file.