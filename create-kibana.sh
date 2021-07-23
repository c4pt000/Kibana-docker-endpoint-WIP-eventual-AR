#!/bin/bash
echo "cd to a directory with VM images like KVM_IMAGES or a VM directory on your host"
yum install docker-compose -y
cd 
mkdir elasticsearch-kibana-setup 
cd elasticsearch-kibana-setup 
touch docker-compose.yml

echo '
version: '3'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.13.4
    ports:
      - 9200:9200
    volumes:
      - ./elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml

  kibana:
    depends_on:
      - elasticsearch  
    image: docker.elastic.co/kibana/kibana:7.13.4
    ports:
      - 5601:5601
    volumes:
      - ./kibana.yml:/usr/share/kibana/config/kibana.yml
' > docker-compose.yml


echo '
cluster.name: my-elasticsearch-cluster
network.host: 0.0.0.0
xpack.security.enabled: false
' > elasticsearch.yml

echo '
server.name: kibana
server.host: "0"
elasticsearch.hosts: [ "http://elasticsearch:9200" ] ' > kibana.yml

docker-compose up
