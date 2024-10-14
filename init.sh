#!/bin/sh

mkdir /opt/opensearch-pod
mkdir /opt/opensearch-pod/data
mkdir /opt/opensearch-pod/data/app

CONTAINER_ID=$(podman create docker.io/opensearchproject/opensearch:2)
podman cp ${CONTAINER_ID}:/usr/share/opensearch/plugins /opt/opensearch-pod/data/
podman rm ${CONTAINER_ID}

chown 1000:1000 -R /opt/opensearch-pod/data/app
chown 1000:1000 -R /opt/opensearch-pod/data/plugins

cp ./opensearch-pod.yaml /opt/opensearch-pod
cp ./opensearch-pod.kube /usr/share/containers/systemd/
