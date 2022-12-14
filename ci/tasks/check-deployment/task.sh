#!/bin/bash

set -ue
source ci/lib/deploy-functions.sh
cf-setup
pipeline_health_check_enabled="${pipeline_health_check_enabled:-true}"
if [ $pipeline_health_check_enabled == true ]; then
  if [ -z ${app_path+x} ]; then
    check-health ${app_url}
  else
    check-health "$app_url/${app_path}"
  fi
fi
