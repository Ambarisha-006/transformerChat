#!/bin/bash

set -eu

echo "Logging into ${CF_API} and targeting ${CF_SPACE}"
cf api ${CF_API} --skip-ssl-validation
set +x
CF_DIAL_TIMEOUT=300 cf auth ${CF_USER} ${CF_PASSWORD}
cf target -o ${CF_ORG} -s "${CF_SPACE}"

echo "BGD post cleanup"
cf delete ${CF_APP}-new -r -f 
cf delete-orphaned-routes -f
