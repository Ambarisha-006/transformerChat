#!/bin/bash
set -ue

chown -R builder /tmp/build
sudo -u builder mvn clean test -s /usr/share/maven/ref/settings.xml
cp -r * ../git-app-target/
