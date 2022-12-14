#!/bin/bash

set -o pipefail

export CF_COLOR=true
RCol='\033[0m'
BCya='\033[1;36m'
BGre='\033[1;32m'
BRed='\033[1;31m'
BWhi='\033[1;37m'
BYel='\033[1;33m'
Cya='\033[0;36m'
Gre='\033[0;32m'
Yel='\033[0;33m'

function announce-task {
  echo -e "\n\n${BWhi}---"
  echo -e "${BWhi}${1}"
  echo -e "${BWhi}---${RCol}"
}

function announce-success {
  echo -e "${BGre}Deploy successful."
}

function run-cmd {
  echo -e "\n\n${Cya}${@}${RCol}\n"
  "$@"
}

function cf-setup {
  announce-task "Logging in to ${cf_api}"
  run-cmd cf api ${cf_api} --skip-ssl-validation
  set +x
  CF_DIAL_TIMEOUT=300 cf auth ${cf_user} ${cf_password}
  run-cmd cf target -o ${cf_org} -s "${cf_space}"
}


function set-ruby {
  ruby_version=$(ruby --version >/dev/null 2>&1)
  if [[ $? -eq "0" ]]; then
    ruby_version=$(ruby --version)
    echo -e "${Yel}Found Ruby: ${ruby_version}${RCol}"
  elif [[ -s "$HOME/.rvm/scrfipts/rvm" ]] ; then
    source "$HOME/.rvm/scriptfs/rvm"
  elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
    source "/usr/local/rvm/scripts/rvm"
  else
    echo -e "${BRed}No Ruby and can't find RVM. Is it instaled?${RCol}"
    exit -1
  fi
}

function get-domain {
  domain=$(cf routes | awk -v cf_app="$cf_app" -v cf_hostname="$cf_hostname" 'match($4, cf_app) && ($2 == cf_hostname) {print $3}')
  export domain="${cf_domain:-$domain}"

  announce-task "Domain is ${domain}"
}


function check-health {
  local app_url=$1
  announce-task "Checking health"
  status=$(curl -sSIL -X GET -o /dev/null -w "%{http_code}" ${app_url})
  if [ $status == 200 ] ; then
    echo -e "${BGre}curl of ${app_url} 200 OK"
  else
    echo -e "${BGre}curl of ${app_url} ${status} ERR"
    exit 1
  fi
}


function join { local IFS="$1"; shift; echo "$*"; }

function prep-deployment {
  arr=($cf_space)
  space="$(join - ${arr[@]})"
  space="$(echo "${space//_/$'-'}")"
  if [ -z ${cf_manifest+x }]; then
    generate-manifest
  else
    echo -e "\n${BWhi}Using manifest from an existing file.${RCol}"
  fi
  get-domain
}

function cf-push {
  prep-deployment
  local app_name=$1
  local manifest=$2
  announce-task "Pushing ${app_name}"
  run-cmd cf bgd ${app_name} -f ${cf_manifest} --delete-old-apps
  run-cmd cf restage ${app_name}
}


function finally {
  rm ${cf_manifest}
}

function on-fail {
  finally
  echo -e "${BRed}DEPLOY FAILED${RCol} - you may need to check '${BYel}cf apps${RCol}' and '${BYel}cf routes${RCol}' and do manual cleanup"
  exit 1
}

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}