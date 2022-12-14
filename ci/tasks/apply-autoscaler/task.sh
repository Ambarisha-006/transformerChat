#!/bin/bash

set -eu

if [[ ${ENABLE_AUTOSCALE} == "true" ]] ; then
    echo "Logging into ${CF_API} and targeting ${CF_SPACE}"
    cf api ${CF_API} --skip-ssl-validation
    set +x
    CF_DIAL_TIMEOUT=300 cf auth ${CF_USER} ${CF_PASSWORD}
    cf target -o ${CF_ORG} -s "${CF_SPACE}"

    #Set rules for autoscaling from manifest
    autoscaler_manifest=ci/config/autoscale-manifests/$CF_ENV/$MANIFEST

    cf configure-autoscaling $CF_APP $autoscaler_manifest

else
	echo "Autoscale is disabled"
fi