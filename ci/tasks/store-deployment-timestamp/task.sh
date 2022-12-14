#!/bin/bash

MVN_VERSION=$(mvn -s /usr/share/maven/ref/settings.xml -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive exec:exec)
MAJOR_VERSION=$(echo ${MVN_VERSION} |awk -F "." '{print $1}')
MINOR_VERSION=$(echo ${MVN_VERSION} |awk -F "." '{print $2}')
TMP_VERSION=$(cat ../version/version)
CONCOURSE_BUILD_VERSION=$(printf "%04d\n" $(( 10#${TMP_VERSION//./})))
APP_BUILD=$(jq '.buildInfo.number' ../app-build/build-info.json | tr -d '"')

version=${MAJOR_VERSION}.${MINOR_VERSION}.${CONCOURSE_BUILD_VERSION}
datestamp=$(date +%Y-%m-%d_%H:%M:%S%z)

s3_deployment_filename="${cf_space}_${datestamp}_${version}_${APP_BUILD}.txt"

echo "S3 deployment filename: ${s3_deployment_filename}"

touch ../s3-app-deployments/${s3_deployment_filename}
