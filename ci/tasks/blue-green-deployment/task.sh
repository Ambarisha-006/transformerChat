#!/bin/bash

set -eu

echo "Logging into ${CF_API} and targeting ${CF_SPACE}"
cf api ${CF_API} --skip-ssl-validation
set +x
CF_DIAL_TIMEOUT=300 cf auth ${CF_USER} ${CF_PASSWORD}
cf target -o ${CF_ORG} -s "${CF_SPACE}"

echo deploying $(ls $BUILD_DIRECTORY/$ARTIFACTORY_PATH/$APP_PACKAGE_FILENAME/*/$APP_PACKAGE_FILENAME*$PACKAGE_EXTENSION) package
unzip $BUILD_DIRECTORY/$ARTIFACTORY_PATH/$APP_PACKAGE_FILENAME/*/$APP_PACKAGE_FILENAME*$PACKAGE_EXTENSION -d "$BUILD_DIRECTORY/$APP_PACKAGE_FILENAME" > /dev/null
export app_directory="$BUILD_DIRECTORY/$APP_PACKAGE_FILENAME"

cd $app_directory
cf bgd ${CF_APP} -f ../../git-app-pipeline/ci/config/app-manifests/${CF_ENV}/${CF_MANIFEST} --delete-old-apps
cf restage ${CF_APP}
