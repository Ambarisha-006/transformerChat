#!/bin/bash

PrIndex=$(cat ../pull-request/.git/resource/metadata.json |jq '.[0].value|tonumber')
sonar-scanner -Dsonar.host.url=$SONAR_URL -Dsonar.projectKey=$SONAR_PROJECT_KEY -Dsonar.projectName=$SONAR_PROJECT_NAME-$SONAR_PROJECT_KEY -Dsonar.login=$SONAR_TOKEN -Dsonar.analysis.mode=preview -Dsonar.github.pullRequest=$PrIndex -Dsonar.github.repository=$GITHUB_REPOSITORY -Dsonar.github.oauth=$GITHUB_ACCESS_TOKEN
