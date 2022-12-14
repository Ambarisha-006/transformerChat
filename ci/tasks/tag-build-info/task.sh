#!/bin/bash

MVN_VERSION=$(mvn -s /usr/share/maven/ref/settings.xml -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive exec:exec)
MAJOR_VERSION=$(echo ${MVN_VERSION} |awk -F "." '{print $1}')
MINOR_VERSION=$(echo ${MVN_VERSION} |awk -F "." '{print $2}')
TMP_VERSION=$(cat ../version/version)
CONCOURSE_BUILD_VERSION=$(printf "%04d\n" $(( 10#${TMP_VERSION//./})))
APP_BUILD=$(jq '.buildInfo.number' ../app-build/build-info.json | tr -d '"')

version=${MAJOR_VERSION}.${MINOR_VERSION}.${CONCOURSE_BUILD_VERSION}
datestamp=$(date +%Y-%m-%d_%H:%M:%S%z)


build_commit_id=$(jq '.buildInfo.properties.BUILD_COMMIT_ID' ../app-build/build-info.json | tr -d '"')
echo "APP BUILD: ${APP_BUILD} Build commit id:${build_commit_id}"

cd ..
git config --global user.name "Concourse"
git config --global user.email "concourse@smarsh.com"

git clone git-app-latest git-app-latest-out

pushd git-app-latest-out
git tag ${APP_BUILD}-${cf_space} ${build_commit_id}
popd 