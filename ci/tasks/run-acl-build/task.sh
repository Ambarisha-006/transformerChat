#!/bin/bash
set -ue

MVN_VERSION=$(mvn -s /usr/share/maven/ref/settings.xml -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive exec:exec)
MAJOR_VERSION=$(echo ${MVN_VERSION} |awk -F "." '{print $1}')
MINOR_VERSION=$(echo ${MVN_VERSION} |awk -F "." '{print $2}')
TMP_VERSION=$(cat ../version/version)
CONCOURSE_BUILD_VERSION=$(printf "%04d\n" $(( 10#${TMP_VERSION//./})))
NEW_VERSION=${MAJOR_VERSION}.${MINOR_VERSION}.${CONCOURSE_BUILD_VERSION}
mvn versions:set -DnewVersion=${NEW_VERSION} -s /usr/share/maven/ref/settings.xml
mvn clean install -DskipTests -Panalyze-acl -s /usr/share/maven/ref/settings.xml

mkdir -p ../build-package-output/com/smarsh
acl_matrix_zip_path=$(find . -name acl-matrix.zip | head -n 1)
cp $acl_matrix_zip_path /root/.m2/repository/${artifactory_path}/${artifactory_sub_directory}/${NEW_VERSION}/${artifactory_sub_directory}-${NEW_VERSION}.zip
cp -r `ls -d /root/.m2/repository/$artifactory_path/**  | egrep -i $artifactory_directory` ../build-package-output/com/smarsh
rm -rf ../build-package-output/com/smarsh/*-deployment
