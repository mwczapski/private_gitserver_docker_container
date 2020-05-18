#!/bin/bash
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -ur fn__GitserverGeneric="SOURCED"

# common environment variable values and utility functions
#
[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
[[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh
[[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh



##
## local functions
##
function fn__AddGITServerToLocalKnown_hostsAndTestSshAccess() {
  # introduce server to client
  #
    local -r lUsage='
  Usage: 
    fn__AddGITServerToLocalKnown_hostsAndTestSshAccess \
      ${__GIT_CLIENT_CONTAINER_NAME} \
      ${__GIT_CLIENT_USERNAME} \
      ${__GIT_CLIENT_SHELL} \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
  [[ $# -lt 3 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pClientContainerName=${1?"${lUsage}"}
  local -r pClientUsername=${2?"${lUsage}"}
  local -r pShellInContainer=${3?"${lUsage}"}

  local -r _CMD_="
    ssh-keyscan -H ${__GITSERVER_HOST_NAME} >> ~/.ssh/known_hosts &&
    ssh git@${__GITSERVER_HOST_NAME} list && echo 'Can connect to the remote git repo' || echo 'Cannot connect to the remote git repo'
    "

  _CMD_OUTPUT_=""
  fn__ExecCommandInContainerGetOutput \
    ${pClientContainerName} \
    ${pClientUsername} \
    ${pShellInContainer} \
    "${_CMD_}" \
    "_CMD_OUTPUT_" \
      && return ${__DONE} \
      || return ${__FAILED}
}


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
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
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
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
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
# echo "xxxxxx ${lCommandOutput}"
  # grep "^${pClientRemoteGitRepoName}$" >/dev/null <<<"${lCommandOutput}" \
  grep "^${pClientRemoteGitRepoName}$" <<<"${lCommandOutput}" \
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
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
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
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
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
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
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
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
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


function fn__UpdateOwnershipOfNonRootUserResources() {
  local lUsage='
      Usage: 
        fn__UpdateOwnershipOfNonRootUserResources  \
          ${__GIT_CLIENT_CONTAINER_NAME} \
          ${__GIT_USERNAME} \
          ${DEBMIN_GUEST_HOME}  \
          ${__GIT_CLIENT_SHELL}  \
          ${__GITSERVER_REPOS_ROOT}
      '
  [[ $# -lt  4 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
  pContainerName=${1?"${lUsage}"}
  pGitUsername=${2?"${lUsage}"}
  pGuestHome=${3?"${lUsage}"}
  pContainerShell=${4?"${lUsage}"}
  pGitReposRoot=${5?"${lUsage}"}

  ${__DOCKER_EXE} container exec -itu root -w ${pGitReposRoot} ${pContainerName} ${pContainerShell} -lc "
  chown -R ${pGitUsername}:${pGitUsername} ${pGuestHome}
  chown -R ${pGitUsername}:${pGitUsername} ${pGitReposRoot}
  "
  echo "______ Updated ownership of ${pGitUsername} resources on ${pContainerName}"
}




:<<-'COMMENT--fn__GetRemoteGitRepoName-----------------------------------------'
  Usage:
    fn__GetRemoteGitRepoName
      ${__GIT_CLIENT_REMOTE_REPO_NAME}
      "__GIT_CLIENT_REMOTE_REPO_NAME" out
  Returns:
    __SUCCESS and the chosen name in __GIT_CLIENT_CONTAINER_NAME ref variable
    __FAILED if there were insufficient arguments, all opportunities to choose a name were exhausted or other unrecoverable errors occured

COMMENT--fn__GetRemoteGitRepoName-----------------------------------------

function fn__GetRemoteGitRepoName() {
  local -r lUsage='
  Usage: 
    fn__GetRemoteGitRepoName \
      ${__GIT_CLIENT_REMOTE_REPO_NAME}  \
      "__GIT_CLIENT_REMOTE_REPO_NAME" # out
    '
  # this picks up missing arguments
  #
  [[ $# -lt 2 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }

  # name reference variables
  #
  local -r lDefaultGitRemoteRepoName="${1}"
  local -n out__GIT_CLIENT_REMOTE_REPO_NAME=${2} 2>/dev/null

  # this picks up arguments which are empty strings
  # 
  [[ -n lDefaultGitRemoteRepoName ]] 2>/dev/null || { echo "1st Argument value, '${1}', is invalid"; return ${__FAILED} ; }
  [[ -n "${2}" ]] 2>/dev/null || { echo "2nd Argument value, '${2}', is invalid"; return ${__FAILED} ; }

  fn__ConfirmYN "Use default name '${lDefaultGitRemoteRepoName}' as Remote Git Repository name? " && STS=${__YES} || STS=${__NO}
  if [[ ${STS} -eq ${__YES} ]] 
  then
    out__GIT_CLIENT_REMOTE_REPO_NAME=${lDefaultGitRemoteRepoName}
    return ${__YES}
  fi

  inPromptString="_????_ Please enter a valid identifier for Git Repository name (Defaut: '${lDefaultGitRemoteRepoName}'): "
  inMaxLength=${__MAX_CONTAIMER_NAME_LENGTH}
  inTimeoutSecs=${_PROMPTS_TIMEOUT_SECS_}
  outValidValue="${lDefaultGitRemoteRepoName}"

  # read -t 10 resp
  # echo "${FUNCNAME}:${LINENO}: resp: ${resp}"

  fn__GetValidIdentifierInput \
    "inPromptString" \
    "inMaxLength" \
    "inTimeoutSecs" \
    "outValidValue" \
        && STS=$? \
        || STS=$?

  if [[ ${STS} -eq ${__FAILED} ]]
  then
    echo "______ Provided input did not result in a valid identifier - identifier based on input was '${outValidValue}'"
    return ${__FAILED}
  fi
  echo "______ Sanitized Git Repository name will be '${outValidValue}'"

  fn__ConfirmYN "Confirm '${outValidValue}' as Git Repository name? " && STS=$? || STS=$?
  if [[ ${STS} -eq ${__NO} ]]
  then
    out__GIT_CLIENT_REMOTE_REPO_NAME=""
    return ${__NO}
  fi

  out__GIT_CLIENT_REMOTE_REPO_NAME="${outValidValue}"
  return ${__YES}
}
