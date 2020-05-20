#!/bin/bash
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

set -o pipefail
set -o errexit

traperr() {
  echo "ERROR: ------------------------------------------------"
  echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
  echo "ERROR: ------------------------------------------------"
}
set -o errtrace
trap traperr ERR


# common environment variable values and utility functions
#
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
[[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh
[[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh
[[ ${fn__GitserverGeneric} ]] || source ./utils/fn__GitserverGeneric.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh


## ==========================================================================
## internal functions
## ==========================================================================
function fn__InputIsValid() {
  local -r lUsage='
  Usage: 
    fn__InputIsValid 
      "${pClientGitRemoteRepoName}"
      ${pCanonicalClientGitRemoteRepoName} 
      ${pGiterverRemoteRepoNameMaxLen}
        && STS=${__DONE} 
        || STS=${__FAILED}
        '
  [[ $# -lt 3 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pClientGitRemoteRepoName=${1?"${lUsage}"}
  local -r pCanonicalClientGitRemoteRepoName=${2?"${lUsage}"}
  local -r pGiterverRemoteRepoNameMaxLen=${3?"${lUsage}"}

  [[ ${#pCanonicalClientGitRemoteRepoName} -lt 2 ]] && {
    echo "______ Git repository name '${pClientGitRemoteRepoName}' translated to '${pCanonicalClientGitRemoteRepoName}'"
    echo "______ Git repository name must be at least 2 characters long"
    return ${__FAILED}
  }
  [[ ${#pCanonicalClientGitRemoteRepoName} -gt ${pGiterverRemoteRepoNameMaxLen} ]] && {
    echo "______ Final Git repository name '${pCanonicalClientGitRemoteRepoName}' is longer than the maximum of ${pGiterverRemoteRepoNameMaxLen} characters"
    echo "______ Git repository name must be no longer than ${pGiterverRemoteRepoNameMaxLen} characters"
    return ${__FAILED}
  }

  return ${__DONE}
}



## ##########################################################################################
## ##########################################################################################
## 
## ##########################################################################################
## ##########################################################################################

# see if repo name has been provided as $1 - if yes, use it, if no use the default
#

# need remote repo name a which to dleete, if empty
#
declare pClientGitRemoteRepoName=${1:-${__GITSERVER_REM_TEST_REPO_NAME}}

# validate repository name
#
lCanonicalClientGitRemoteRepoName=$( fn__SanitizeInputAlphaNum ${pClientGitRemoteRepoName} )

fn__InputIsValid \
  "${pClientGitRemoteRepoName}" \
  ${lCanonicalClientGitRemoteRepoName} \
  ${__GITSERVER_REMOTE_REPO_NAME_MAX_LEN} || {
    echo "______ (${LINENO}) Aborting ..."
    exit ${__FAILED}
  }
echo "______ Input accepted as ${lCanonicalClientGitRemoteRepoName}"

fn__IsSSHToRemoteServerAuthorised \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GIT_HOST_PORT} \
  ${__GITSERVER_SHELL} && STS=$? || STS=$?

if [[ $STS -eq ${__NO} ]]; then
  echo "______ Client not authorised to connect to the server - please contact server administrator"
  echo "______ (${LINENO}) Aborting ..."
  exit ${__FAILED}
fi
echo "______ Client authorised to interact with the server"


fn__DoesRepoAlreadyExist \
  ${lCanonicalClientGitRemoteRepoName}  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} && STS=$? || STS=$? # can be __NO or __EXECUTION_ERROR

  [[ ${STS} -eq ${__EXECUTION_ERROR} ]] && {
      echo "______ Failed to determine whether Git Repository ${lCanonicalClientGitRemoteRepoName} already exists - aborting"
      exit ${__FAILED}
  }
  [[ ${STS} -eq ${__NO} ]] && {
      echo "______ Git Repository ${lCanonicalClientGitRemoteRepoName} does not exists - aborting"
      exit ${__FAILED}
  }
echo "______ Repository ${lCanonicalCanonicalClientGitRemoteRepoName} exists"
 

fn__IsRepositoryEmpty \
  ${__GITSERVER_REPOS_ROOT} \
  ${lCanonicalClientGitRemoteRepoName}  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} && STS=${__YES} || STS=${__NO}

if [[ $STS -eq ${__NO} ]]
then
  echo "______ Repository ${lCanonicalClientGitRemoteRepoName} is not empty - can't delete it using this method - please see server administrator"
  echo "______ (${LINENO}) Aborting ..."
  exit ${__FAILED}
fi
echo "______ Repository ${lCanonicalClientGitRemoteRepoName} is empty"

fn__DeleteEmptyRemoteRepository \
  ${lCanonicalClientGitRemoteRepoName}  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} \
  ${__GITSERVER_REPOS_ROOT} \
    && STS=${__DONE} \
    || STS=${__FAILED}

if [[ $STS -eq ${__FAILED} ]]
then
  echo "______ Failed to delete repository ${lCanonicalClientGitRemoteRepoName} - please see server administrator"
  echo "______ (${LINENO}) Aborting ..."
  exit ${__FAILED}
fi

fn__DoesRepoAlreadyExist \
  ${lCanonicalClientGitRemoteRepoName}  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} && STS=$? || STS=$? # can be __NO or __EXECUTION_ERROR

  [[ ${STS} -eq ${__EXECUTION_ERROR} ]] && {
      echo "______ Failed to determine whether Git Repository ${lCanonicalClientGitRemoteRepoName} still exists - aborting"
      exit ${__FAILED}
  }
  [[ ${STS} -eq ${__YES} ]] && {
      echo "______ Git Repository ${lCanonicalClientGitRemoteRepoName} still exists - please see server administrator"
      exit ${__FAILED}
  }
echo "______ Repository ${lCanonicalCanonicalClientGitRemoteRepoName} deleted"

exit ${__DONE} 
