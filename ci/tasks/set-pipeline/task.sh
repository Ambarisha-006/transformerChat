#!/bin/bash

set -e

echo "Concourse login ..."

# This is necessary because Smarsh uses Cloud Foundry's UAA for Concourse user authentication, and it's not possible to do a regulary `fly login`
ruby git-app-pipeline/ci/tasks/set-pipeline/fly_login.rb \
      "${CONCOURSE_USERNAME}" \
      "${CONCOURSE_PASSWORD}" \
      "${CONCOURSE_TEAM}" \
      "${CONCOURSE_URL}" \
      "${CONCOURSE_TEAM}"


fly -t "${CONCOURSE_TEAM}" sync
fly --target "${CONCOURSE_TEAM}" set-pipeline \
  --pipeline "${PIPELINE_NAME}" \
  --config git-app-pipeline/"${PIPELINE_PATH}" \
  --non-interactive 

fly --target "${CONCOURSE_TEAM}" unpause-pipeline --pipeline "${PIPELINE_NAME}"
