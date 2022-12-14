#!/usr/bin/env bash
# Define the variables with values you want replaced
if [ "$#" -ne 8 ]; then
    echo "Illegal number of arguments"
    exit 1
fi

ACCESS_KEY=$1
SECRET_KEY=$2
AWS_REGION=$3
ACL_USER=$4
ACL_PASSWORD=$5
ARTIFACT_ID=$6
BUCKET_SPACE=$7
BUCKET_FOLDER=$8

function generate_httpd_conf {
  echo "#### Creating application.properties from template application.properties.tmpl"
  cp ci/tasks/task-files-to-s3/application.properties.tmpl ci/tasks/task-files-to-s3/application.properties 
  sed -i -e "s/ACCESS_KEY/$ACCESS_KEY/g" ci/tasks/task-files-to-s3/application.properties 
  sed -i -e "s/SECRET_KEY/$SECRET_KEY/g" ci/tasks/task-files-to-s3/application.properties 
  sed -i -e "s/AWS_REGION/$AWS_REGION/g" ci/tasks/task-files-to-s3/application.properties 
  sed -i -e "s/ACL_USER/$ACL_USER/g" ci/tasks/task-files-to-s3/application.properties 
  sed -i -e "s/ACL_PASSWORD/$ACL_PASSWORD/g" ci/tasks/task-files-to-s3/application.properties 
  sed -i -e "s/BUCKET_SPACE/$BUCKET_SPACE/g" ci/tasks/task-files-to-s3/application.properties 
  sed -i -e "s/BUCKET_FOLDER/$BUCKET_FOLDER/g" ci/tasks/task-files-to-s3/application.properties 
}

function generate_artifacts_json {
  echo "#### Customize artifacts.json"
  sed -i "s/ARTIFACT_ID/$ARTIFACT_ID/g" ci/tasks/task-files-to-s3/artifacts.json
}

generate_httpd_conf
generate_artifacts_json