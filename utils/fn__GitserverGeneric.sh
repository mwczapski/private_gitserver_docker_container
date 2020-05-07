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
  [[ $# -lt 4 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
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
  [[ $# -lt 4 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
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

  lCommandOutput=$( ${lCommand}) || {
      echo "______ Failed to execute ${lCommand} - Status: $? - aborting"
      exit
    }

  grep "^${pClientRemoteGitRepoName}$" >/dev/null <<<"${lCommandOutput}" \
    && STS=${__YES} \
    || STS=${__NO}

  return ${STS}
}


function fn__IsRepositoryEmpty() {

  # introduce client's id_rsa public key to gitserver, which needs it to allow git test client access over ssh
  #
  local -r lUsage='
  Usage: 
    fn__IsRepositoryEmpty \
      ${__GITSERVER_REPOS_ROOT} \
      ${__CLIENT_REMOTE_GIT_REPO_NAME_}  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
  [[ $# -lt 5 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pGitserverReposRoot=${1?"${lUsage}"}
  local -r pClientRemoteGitRepoName=${2?"${lUsage}"}
  local -r pServerContainerName=${3?"${lUsage}"}
  local -r pServerUsername=${4?"${lUsage}"}
  local -r pShellInContainer=${5?"${lUsage}"}


  local -r lCommand="
    { cd ${pGitserverReposRoot}/${pClientRemoteGitRepoName}.git || exit ${__EXECUTION_ERROR} ; } && \
    objCount=\$(git count-objects) &&
    echo \${objCount%% *}
    exit ${__DONE}
  "

  local lCommandOutput=""
  fn__ExecCommandInContainerGetOutput \
    ${pServerContainerName} \
    ${pServerUsername} \
    ${pShellInContainer} \
    "${lCommand}" \
    "lCommandOutput" && STS=$? || STS=$?

  if [[ $STS -ne ${__SUCCESS} ]]
  then
    return ${__NO}
  fi

  if [[ "${lCommandOutput}" == "0" ]]
  then
    return ${__YES}
  else
    return ${__NO}
  fi
}


function fn__CreateNewClientGitRepositoryOnRemote() {
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
  [[ $# -lt 5 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
  }
  local -r pClientRemoteGitRepoName=${1?"${lUsage}"}
  local -r pServerContainerName=${2?"${lUsage}"}
  local -r pServerUsername=${3?"${lUsage}"}
  local -r pShellInContainer=${4?"${lUsage}"}
  local -r pGitServerReposRoot=${5?"${lUsage}"}

  lCommand="
    mkdir -p ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git \
    && chown -R ${pServerUsername}:developers  ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git \
    && chmod g+s ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git \
    && cd ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git \
    && su - -s ${pShellInContainer} -c 'git init --bare ${pGitServerReposRoot}/${pClientRemoteGitRepoName}.git' ${pServerUsername}; \
    "

  fn__ExecCommandInContainer \
    ${pServerContainerName} \
    "root" \
    ${pShellInContainer} \
    "${lCommand}" \
      && STS=${__DONE} \
      || STS=${__FAILED}

}

function fn__DeleteEmptyRemoteRepository() {
    local -r lUsage='
  Usage: 
    fn__DeleteEmptyRemoteRepository \
      ${__CLIENT_REMOTE_GIT_REPO_NAME_}  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
      ${__GITSERVER_REPOS_ROOT} \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
  [[ $# -lt 5 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }

  local -r pClientRemoteGitRepoName=${1?"${lUsage}"}
  local -r pServerContainerName=${2?"${lUsage}"}
  local -r pServerUsername=${3?"${lUsage}"}
  local -r pShellInContainer=${4?"${lUsage}"}
  local -r pGitServerReposRoot=${5?"${lUsage}"}

  lCommand="
    cd ${pGitServerReposRoot} \
    && rm -Rf ${pClientRemoteGitRepoName}.git \
    "

  fn__ExecCommandInContainer \
    ${pServerContainerName} \
    "root" \
    ${pShellInContainer} \
    "${lCommand}" \
      && STS=${__DONE} \
      || STS=${__FAILED}

  return ${STS}
}


function fn__IsSSHToRemoteServerAuthorised() {
  local -r lUsage='
  Usage: 
    fn__IsSSHToRemoteServerAuthorised 
      ${__GITSERVER_CONTAINER_NAME}
      ${__GIT_USERNAME} 
      ${__GIT_HOST_PORT}
        && STS=${__YES} 
        || STS=${__NO}
        '
  [[ $# -lt 3 || "${0^^}" == "HELP" ]] && {
    echo -e "__ER__ Insufficient number of arguments\n${lUsage}"
    return ${__FAILED}
  }

  local -r pServerContainerName=${1?"${lUsage}"}
  local -r pServerUsername=${2?"${lUsage}"}
  local -r pHostPort=${3?"${lUsage}"}

  local lLinux=${SHELL:-NO}
  local lWSL=${WSL_DISTRO_NAME:-NO}
  [[ "${lLinux}" == "NO" ]] && lLinux=1 || lLinux=0
  [[ "${lWSL}" == "NO" ]] && lWSL=1 || lWSL=0
  
  local lCommand=""
  if [[ ${lWSL} -eq ${__YES} ]]
  then
      lCommand="ssh ${pServerUsername}@localhost -p ${pHostPort} list"
  else 
      lCommand="ssh ${pServerUsername}@${pServerContainerName} list"
  fi

  lCommandOutput=$(${lCommand}) && STS=$? ||STS=$?

  return ${STS}
}
