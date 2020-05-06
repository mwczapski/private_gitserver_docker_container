#!/bin/bash
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -ur fn__GitserverGeneric="SOURCED"

# common environment variable values and utility functions
#
[[ ${__env_YesNoSuccessFailureContants} ]] || source ./utils/__env_YesNoSuccessFailureContants.sh
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
[[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh
[[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh

echo "______ Sourced common variables and functions"; 


##
## local functions
##
function fn__AddClientPublicKeyToServerAuthorisedKeysStore() {

  # introduce client's id_rsa public key to gitserver, which needs it to allow git test client access over ssh
  #
  [[ $# -lt 4 || "${0^^}" == "HELP" ]] && {
    local -r lUsage='
  Usage: 
    fn__AddClientPublicKeyToServerAuthorisedKeysStore \
      ${__GIT_CLIENT_ID_RSA_PUB_}  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
    return ${__FAILED}
  }
 
  local -r pClient_id_rsa_pub=${1?"${lUsage}"}
  local -r pServerContainerName=${2?"${lUsage}"}
  local -r pServerUsername=${3?"${lUsage}"}
  local -r pShellInContainer=${4?"${lUsage}"}

  local -r lClientId=${pClient_id_rsa_pub//* /}

  local -r lCommand="
    { test -e \${HOME}/.ssh/authorized_keys \
      || touch \${HOME}/.ssh/authorized_keys ; } &&

    { mv \${HOME}/.ssh/authorized_keys ~/.ssh/authorized_keys_previous &&
    chmod 0600 \${HOME}/.ssh/authorized_keys_previous ; } &&

    { test -e \${HOME}/.ssh/authorized_keys \
      && cp \${HOME}/.ssh/authorized_keys \${HOME}/.ssh/authorized_keys_previous \
      || touch \${HOME}/.ssh/authorized_keys \${HOME}/.ssh/authorized_keys_previous ; } &&

    sed \"/${lClientId}/d\" \${HOME}/.ssh/authorized_keys_previous > \${HOME}/.ssh/authorized_keys &&

    echo "\"${pClient_id_rsa_pub}\"" >> \${HOME}/.ssh/authorized_keys &&

    cat \${HOME}/.ssh/authorized_keys
  "

  local lCommandOutput=""
  fn__ExecCommandInContainerGetOutput \
    ${pServerContainerName} \
    ${pServerUsername} \
    ${pShellInContainer} \
    "${lCommand}" \
    "lCommandOutput" \
      && return ${__DONE} \
      || return ${__FAILED}
}


function fn__DoesRepoAlreadyExist() {
  [[ $# -lt 4 || "${0^^}" == "HELP" ]] && {
    local -r lUsage='
  Usage: 
    fn__DoesRepoAlreadyExist \
      ${__CLIENT_REMOTE_GIT_REPO_NAME_}  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
        && STS=${__YES} \
        || STS=${__NO}
        '
    return ${__EXECUTION_ERROR}
  }
 
  local -r pClientRemoteGitRepoName=${1?"${lUsage}"}
  local -r pServerContainerName=${2?"${lUsage}"}
  local -r pServerUsername=${3?"${lUsage}"}
  local -r pShellInContainer=${4?"${lUsage}"}

  local lLinux=${SHELL:-NO}
  local lWSL=${WSL_DISTRO_NAME:-NO}
  [[ "${lLinux}" == "NO" ]] && lLinux=1 || lLinux=0
  [[ "${lWSL}" == "NO" ]] && lWSL=1 || lWSL=0
  
  local lCommand=""
  [[ ${lWSL} -eq ${__YES} ]] \
    && {
      lCommand="ssh ${__GIT_USERNAME}@localhost -p ${__GIT_HOST_PORT} list"
    } \
    || {
      lCommand="ssh ${__GIT_USERNAME}@${__GITSERVER_CONTAINER_NAME} list"
    }

  lCommandOutput=$(${lCommand}) \
    || {
      echo "______ Failed to execute ${lCommand} - Status: $? - aborting"
      exit
    }

  grep "${pClientRemoteGitRepoName}" <<<"${lCommandOutput}" \
    && STS=${__YES} \
    || STS=${__NO}

  return ${STS}
}


function fn__CreateNewClientGitRepositoryOnRemote() {
  [[ $# -lt 5 || "${0^^}" == "HELP" ]] && {
    local -r lUsage='
  Usage: 
    fn__CreateNewClientGitRepositoryOnRemote \
      ${__CLIENT_REMOTE_GIT_REPO_NAME_}  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
      ${__GITSERVER_REPOS_ROOT} \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
  }
  local -r pClientRemoteGitRepoName=${1?"${lUsage}"}
  local -r pServerContainerName=${2?"${lUsage}"}
  local -r pServerUsername=${3?"${lUsage}"}
  local -r pShellInContainer=${4?"${lUsage}"}
  local -r pGitServerReposRoot=${5?"${lUsage}"}

  lCommand="
  ( [[ -d  ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git ]] && \
  rm -Rfv  ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git ; ) ;\
  { 
    mkdir -pv ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git \
    && chown -Rv ${pServerUsername}:developers  ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git \
    && chmod -v g+s ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git \
    && cd ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git \
    && su - -s ${pShellInContainer} -c 'git init --bare ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git' ${pServerUsername}; \
    }"

  fn__ExecCommandInContainer \
    ${pServerContainerName} \
    "root" \
    ${pShellInContainer} \
    "${lCommand}" \
      && STS=${__DONE} \
      || STS=${__FAILED}

}


## ##########################################################################################
## ##########################################################################################
## 
## ##########################################################################################
## ##########################################################################################

# # see if repo name has been provided as $1 - if yes, use it, if no use the default
# #

# # need remote repo name and location of the id_rsa.pub public key file associated 
# # with the client which wants to access the gitserver
# #
# declare lClientGitRemoteRepoName=${1:-${__GITSERVER_REM_TEST_REPO_NAME}}
# declare lClientIdRSAPubFilePath=${2:-~/.ssh/id_rsa.pub}


# # client id can be extracted form the id_rsa.pub which generated it
# #
# declare lClientIdRSAPub=""
# lClientIdRSAPub=$(cat ${lClientIdRSAPubFilePath}) ||{
#   echo "______ Could not locate public key file ${lClientIdRSAPubFilePath} for this client - aborting"
#   exit ${__FAILED}
# }


# # client's public key must be in git server's authorised_keys file
# #
# fn__AddClientPublicKeyToServerAuthorisedKeysStore \
#   "${lClientIdRSAPub}"  \
#   ${__GITSERVER_CONTAINER_NAME} \
#   ${__GIT_USERNAME} \
#   ${__GITSERVER_SHELL} \
#     && STS=${__DONE} \
#     || STS=${__FAILED}


# # # if repo already exists we can't create a new one with the same name
# # #
# # fn__DoesRepoAlreadyExist \
# #   ${lClientGitRemoteRepoName}  \
# #   ${__GITSERVER_CONTAINER_NAME} \
# #   ${__GIT_USERNAME} \
# #   ${__GITSERVER_SHELL} \
# #     && {
# #       echo "______ Git Repository ${lClientGitRemoteRepoName} already exists - aborting"
# #       exit
# #     } \
# #     || STS=$? # can be __NO or __EXECUTION_ERROR

# #   [[ ${STS} -eq ${__EXECUTION_ERROR} ]] && {
# #       echo "______ Failed to determine whether Git Repository ${lClientGitRemoteRepoName} already exists - aborting"
# #       exit 
# #   }

# # fn__CreateNewClientGitRepositoryOnRemote \
# #   ${lClientGitRemoteRepoName}  \
# #   ${__GITSERVER_CONTAINER_NAME} \
# #   ${__GIT_USERNAME} \
# #   ${__GITSERVER_SHELL} \
# #   ${__GITSERVER_REPOS_ROOT} \
# #     && {
# #       echo "______ Created remote repository ${lClientGitRemoteRepoName}"
# #     } \
# #     || {
# #       echo "______ Failed to create remote repository ${lClientGitRemoteRepoName}"
# #     }
