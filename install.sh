#! /bin/bash
VERSION=0.18.1

wget  https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz

tar xvf node_exporter-$VERSION.linux-amd64.tar.gz

cp node_exporter-$VERSION.linux-amd64/node_exporter /usr/local/bin/node_exporter

exists=$(grep -c "^node_exporter:" /etc/passwd) && echo $exists

if [ $exists -eq 0 ]; then
    useradd -m -s /bin/bash node_exporter

fi 
rm -rf node_exporter-$VERSION.linux-amd64.tar.gz node_exporter-$VERSION.linux-amd64

wget -O /etc/systemd/system/node_exporter.service   https://raw.githubusercontent.com/vantamm27/node_exporter/master/node_exporter.service


systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
#systemctl status node_exporter

mkdir -p /opt/iot/node_exporter

echo '#!/bin/bash' > /opt/iot/node_exporter/node_exporter.sh
echo "PUSHGATEWAY_SERVER=$ENDPOINT" >>  /opt/iot/node_exporter/node_exporter.sh
echo "NODE_NAME=$HOSTNAME" >> /opt/iot/node_exporter/node_exporter.sh 
echo "curl -s localhost:9100/metrics | curl --data-binary @- \$PUSHGATEWAY_SERVER/metrics/job/\$INSTANCE/instance/\$NODE_NAME " >>  /opt/iot/node_exporter/node_exporter.sh 

chmod +x /opt/iot/node_exporter/node_exporter.sh

crontab -l | { cat; echo "*/1 * * * * /opt/iot/node_exporter/node_exporter.sh"; } | crontab -
