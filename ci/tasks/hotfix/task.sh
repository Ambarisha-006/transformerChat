#!/bin/bash

set -ue
source ci/lib/deploy-functions.sh

cf-setup

cd ../git-app-hotfix
mvn install -Dcheckstyle.skip -DskipTests -s /usr/share/maven/ref/settings.xml

run-cmd cf push ${cf_app} -f ${cf_manifest} --vars-file ${cf_manifest_ops_file} --hostname ${cf_hostname} -d ${cf_domain} -p ./$app_package_filename/target/$app_package_filename*$package_extension

check-health $app_path
