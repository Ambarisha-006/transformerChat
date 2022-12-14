#!/bin/bash

set -ue
source ci/lib/deploy-functions.sh
set +eu
set-ruby
set -eu
ruby ci/tasks/datadog-deployment-counter/datadog-deployment-counter.rb
