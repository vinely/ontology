#!/bin/bash

if [ $UID -ne 0 ]; then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
fi

chown root:root ontology ontology.service
chmod a+x ontology
chmod 644 ontology.service
cp -f ontology /usr/local/bin/
cp -f ontology.service /lib/systemd/system/


mkdir -p /root/.ontology/
chmod 600 /root/.ontology
cp -f config.ini config.json /root/.ontology/

cd /root/.ontology/
echo $(< /dev/urandom tr -dc A-Za-z0-9\!\# | head -c ${1:-32}) > ONTO_KEY
cat ONTO_KEY ONTO_KEY | ontology account add -d

echo "Finish setup!"
echo "start service --  systemctl start ontology"
echo "autostart at boot -- systemctl enable ontology"
echo "check log -- tail -f /var/log/syslog"

