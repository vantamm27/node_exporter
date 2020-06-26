#! /bin/bash

VERSION=0.18.1
systemctl stop node_exporter
wget  https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz

tar xvf node_exporter-$VERSION.linux-amd64.tar.gz

cp node_exporter-$VERSION.linux-amd64/node_exporter /usr/local/bin/node_exporter

exists=$(grep -c "^node_exporter:" /etc/passwd) && echo $exists

rm -rf node_exporter-$VERSION.linux-amd64.tar.gz node_exporter-$VERSION.linux-amd64

systemctl start node_exporter
