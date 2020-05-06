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
[[ ${__env_YesNoSuccessFailureContants} ]] || source ./utils/__env_YesNoSuccessFailureContants.sh
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
[[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh
[[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh
[[ ${fn__GitserverGeneric} ]] || source ./utils/fn__GitserverGeneric.sh
# [[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh

echo "______ Sourced common variables and functions"; 


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
declare lClientGitRemoteRepoName=${1:-${__GITSERVER_REM_TEST_REPO_NAME}}
declare lClientIdRSAPubFilePath=${2:-~/.ssh/id_rsa.pub}

echo "______ Set to create remote egit repository ${lClientGitRemoteRepoName}" 
echo "______ Set to use public key for ${lClientGitRemoteRepoName//* /}" 

fn__ConfirmYN "Proceed?" && true || {
  echo "_____ Chose NO - Aborting ..."
  exit
}


# client id can be extracted form the id_rsa.pub which generated it
#
declare lClientIdRSAPub=""
lClientIdRSAPub=$(cat ${lClientIdRSAPubFilePath}) ||{
  echo "______ Could not locate public key file ${lClientIdRSAPubFilePath} for this client - aborting"
  exit ${__FAILED}
}


# client's public key must be in git server's authorised_keys file
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
  ${lClientGitRemoteRepoName}  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} \
    && {
      echo "______ Git Repository ${lClientGitRemoteRepoName} already exists - aborting"
      exit
    } \
    || STS=$? # can be __NO or __EXECUTION_ERROR

  [[ ${STS} -eq ${__EXECUTION_ERROR} ]] && {
      echo "______ Failed to determine whether Git Repository ${lClientGitRemoteRepoName} already exists - aborting"
      exit 
  }

fn__CreateNewClientGitRepositoryOnRemote \
  ${lClientGitRemoteRepoName}  \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GIT_USERNAME} \
  ${__GITSERVER_SHELL} \
  ${__GITSERVER_REPOS_ROOT} \
    && {
      echo "______ Created remote repository ${lClientGitRemoteRepoName}"
    } \
    || {
      echo "______ Failed to create remote repository ${lClientGitRemoteRepoName}"
    }
