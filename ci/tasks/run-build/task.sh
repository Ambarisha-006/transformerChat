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

mkdir -p ../build-package-output/${artifactory_path}
cp -r `ls -d /root/.m2/repository/$artifactory_path/**  | egrep -i $artifactory_directory` ../build-package-output/${artifactory_path}
rm -rf ../build-package-output/${artifactory_path}/*-deployment

echo "Generating build properties file"
git_branch=$(git show-ref --heads | rev | cut -d "/" -f1 | rev)
commit_id=$(git log --format="%H" -n 1)
latest_commit_id=`cat .git/refs/heads/${git_branch}`

echo "BUILD_VERSION=${NEW_VERSION}" >> ../build-package-output/build.properties
echo "BUILD_BRANCH=${git_branch}" >> ../build-package-output/build.properties
echo "BUILD_COMMIT_ID=${commit_id}" >> ../build-package-output/build.properties
echo "BUILD_LATEST_COMMIT_ID=${latest_commit_id}" >> ../build-package-output/build.properties
