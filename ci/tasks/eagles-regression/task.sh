#!/bin/bash

if [[ $skip == "true" ]] ; then
  echo 'task skipped'
else
  #bash scripts/db_tunnelscript.sh $environment $cf_user $cf_password $regression_env
  bash scripts/gen_db_credentials.sh
  echo "target_component:${target_component}"
  cmd="mvn clean test -Dtestng.suite.xml.file=config/components/regression/${target_component}.xml -Dprod.aws.accesskey=${aws_access_key_value} -Dprod.aws.secretkey=${aws_secret_access_key_value} -Dresult.publish.s3=true -Dintegration.tool.testrail=false -Dtarget.env=$regression_env -Dmaven.test.failure.ignore=true"
  #echo $cmd
  eval $cmd
  bash scripts/qualityGateMeasure.sh
fi
