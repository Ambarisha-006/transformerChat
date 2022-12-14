#!/bin/bash

set -ue

echo "Pushing acl to s3"

ls -l ../
new_version=`basename ../file-repository/com/smarsh/acl-matrix-uploader/*`
if [ -f ../file-repository/com/smarsh/acl-matrix-uploader/${new_version}/acl-matrix-uploader-${new_version}.jar ];then
  ls -l ../file-repository/com/smarsh/acl-matrix-uploader/${new_version}/acl-matrix-uploader-${new_version}.jar
  bash ci/tasks/task-files-to-s3/generate_application_properties.sh ${aws_access_key} ${aws_secret_key} ${aws_region} ${artifactory_username} ${artifactory_password} ${artifactory_sub_directory} ${s3_bucket_deployments_space} ${s3_folder}
  java -jar ../file-repository/com/smarsh/acl-matrix-uploader/${new_version}/acl-matrix-uploader-${new_version}.jar --artifacts.source=ci/tasks/task-files-to-s3/artifacts.json --spring.config.location=ci/tasks/task-files-to-s3/application.properties
else
  echo "No acl-matrix-uploader jar file. Skipping"
fi
