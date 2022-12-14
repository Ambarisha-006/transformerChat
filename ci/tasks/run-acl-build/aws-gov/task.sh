#!/bin/bash
set -ue

MVN_VERSION=$(mvn -s /usr/share/maven/ref/settings.xml -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive exec:exec)
MAJOR_VERSION=$(echo "${MVN_VERSION}" | awk -F "." '{print $1}')
MINOR_VERSION=$(echo "${MVN_VERSION}" | awk -F "." '{print $2}')
TMP_VERSION=$(cat ../version/version)
CONCOURSE_BUILD_VERSION=$(printf "%04d\n" $(( 10#${TMP_VERSION//./})))
NEW_VERSION=${MAJOR_VERSION}.${MINOR_VERSION}.${CONCOURSE_BUILD_VERSION}
# shellcheck disable=SC2154
echo "Building ACL for ${artifactory_sub_directory}/${NEW_VERSION}/"

# shellcheck disable=SC2154
echo "Initializing directory ${output_directory}/${artifactory_sub_directory}/${NEW_VERSION}"
mkdir -p "${output_directory}/${artifactory_sub_directory}/${NEW_VERSION}"

echo "Scanning for ACL JSON in source code"
acl_matrix_json_path=$(find . -name "*.acl.json" | head -n 1)
echo "Found ACL JSON at ${acl_matrix_json_path}"

echo "Copying ACL JSON to output directory"
cp "$acl_matrix_json_path" "${output_directory}/acl-matrix.json"
acl_matrix_zip_path="${output_directory}/${artifactory_sub_directory}/${NEW_VERSION}/${artifactory_sub_directory}-${NEW_VERSION}.zip"
echo "Zipping ACL JSON to file ${acl_matrix_zip_path}"
zip -mj "${acl_matrix_zip_path}" "${output_directory}/acl-matrix.json"
