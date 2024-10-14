#!/bin/sh

mkdir /opt/opensearch-pod
mkdir /opt/opensearch-pod/data
mkdir /opt/opensearch-pod/data/app

chown 1000:1000 /opt/opensearch-pod/data/app

cp ./opensearch-pod.yaml /opt/opensearch-pod
cp ./opensearch-pod.kube /usr/share/containers/systemd/
