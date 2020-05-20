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
      ${pClientIdRSAPubFilePath} 
        && STS=${__DONE} 
        || STS=${__FAILED}
        '
  [[ $# -lt 4 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pClientGitRemoteRepoName=${1?"${lUsage}"}
  local -r pCanonicalClientGitRemoteRepoName=${2?"${lUsage}"}
  local -r pGiterverRemoteRepoNameMaxLen=${3?"${lUsage}"}
  local -r pClientIdRSAPubFilePath=${4?"${lUsage}"}

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

  [[ -e ${pClientIdRSAPubFilePath} ]] || {
    echo "______ RSA Public Key '${pClientIdRSAPubFilePath}' not found"
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

# need remote repo name and location of the id_rsa.pub public key file associated 
# with the client which wants to access the gitserver
#
declare pClientGitRemoteRepoName=${1:-${__GITSERVER_REM_TEST_REPO_NAME}}
declare pClientIdRSAPubFilePath=${2:-~/.ssh/id_rsa.pub}


# validate input, if provided
#
lCanonicalClientGitRemoteRepoName=$( fn__SanitizeInputAlphaNum ${pClientGitRemoteRepoName} )

fn__InputIsValid \
  "${pClientGitRemoteRepoName}" \
  ${lCanonicalClientGitRemoteRepoName} \
  ${__GITSERVER_REMOTE_REPO_NAME_MAX_LEN} \
  ${pClientIdRSAPubFilePath} || {
    echo "______ Aborting ..."
    exit ${__FAILED}
  }


# client id can be extracted from the id_rsa.pub which generated it if the file contains a RSA public key
#
declare lClientIdRSAPub=""
lClientIdRSAPub=$(cat ${pClientIdRSAPubFilePath})
[[ ${lClientIdRSAPub// */} == "ssh-rsa" ]] || {
  echo "______ Public key in file ${pClientIdRSAPubFilePath} does not appear to be the RSA public key - aborting"
  exit ${__FAILED}
}


# confirm values
#
echo "______ Set to create remote git repository ${lCanonicalClientGitRemoteRepoName}" 
echo "______ Set to use public key for ${lClientIdRSAPub//* /}" 
fn__ConfirmYN "Proceed?" && true || {
  echo "_____ Chose NO - Aborting ..."
  exit ${__FAILED}
}


# client's public key must be in git server's authorised_keys file for ssh commands do be able to be executed
#
fn__AddClientPublicKeyToServerAuthorisedKeysStore \
  "${lClientIdRSAPub}"  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} \
    && STS=${__DONE} \
    || STS=${__FAILED}


# if repo already exists we can't create a new one with the same name
#
fn__DoesRepoAlreadyExist \
  ${lCanonicalClientGitRemoteRepoName}  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} \
    && {
      echo "______ Git Repository ${lCanonicalClientGitRemoteRepoName} already exists - aborting"
      exit
    } \
    || STS=$? # can be __NO (good) or __EXECUTION_ERROR (bad)

  [[ ${STS} -eq ${__EXECUTION_ERROR} ]] && {
      echo "______ Failed to determine whether Git Repository ${lCanonicalClientGitRemoteRepoName} already exists - aborting"
      exit 
  }


fn__CreateNewClientGitRepositoryOnRemote \
  ${lCanonicalClientGitRemoteRepoName}  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} \
  ${__GITSERVER_REPOS_ROOT} \
    && {
      echo "______ Created remote repository ${lCanonicalClientGitRemoteRepoName}"
      exit ${__DONE}
    } \
    || {
      echo "______ Failed to create remote repository ${lCanonicalClientGitRemoteRepoName}"
      exit ${__FAILED}
    }
