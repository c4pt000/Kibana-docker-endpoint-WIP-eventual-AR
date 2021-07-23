#!/bin/sh

yum install docker-compose -y
 
rm -rf elasticsearch-kibana-setup 
mkdir elasticsearch-kibana-setup 
cd elasticsearch-kibana-setup 
touch docker-compose.yml

echo '
version: "3"
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.8.0
    ports:
      - 9200:9200
    volumes:
      - ./elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml

  kibana:
    depends_on:
      - elasticsearch  
    image: docker.elastic.co/kibana/kibana:6.8.0
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

docker-compose exec elasticsearch bash
bin/elasticsearch-certutil ca
echo "enter, enter, enter here"
bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12

echo '
version: '3'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.8.0
    ports:
      - 9200:9200
    volumes:
      - ./elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
      - ./elastic-certificates.p12:/usr/share/elasticsearch/config/elastic-certificates.p12

  kibana:
    depends_on:
      - elasticsearch
    image: docker.elastic.co/kibana/kibana:6.8.0
    ports:
      - 5601:5601
    volumes:
      - ./kibana.yml:/usr/share/kibana/config/kibana.yml
' > docker-compose.yml

echo '
cluster.name: my-elasticsearch-cluster
network.host: 0.0.0.0
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.keystore.type: PKCS12
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.keystore.path: elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: elastic-certificates.p12
xpack.security.transport.ssl.truststore.type: PKCS12 ' > elasticsearch.yml 

docker-compose up
