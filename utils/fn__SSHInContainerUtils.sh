#!/bin/bash
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -ur fn__SSHInContainerUtils="SOURCED"

# common environment variable values and utility functions
#
[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
# [[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh
# [[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh


##
## local functions
##

function fn__GenerateSSHKeyPairInClientContainer() {
  local -r lUsage='
  Usage: 
    fn__GenerateSSHKeyPairInClientContainer \
      ${__GIT_CLIENT_CONTAINER_NAME} \
      ${__GIT_CLIENT_USERNAME} \
      ${__GIT_CLIENT_SHELL} \
      "__GIT_CLIENT_ID_RSA_PUB_" \
        && return ${__DONE} \
        || return ${__FAILED}
  '
  [[ $# -lt  4 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pClientContainerName=${1?"Container Name to be assigned to the container"}
  local -r pClientUsername=${2?"Host Path, in DOS format, to write shortcuts to"}
  local -r pShellInContainer=${3?"Shell to use on connection to the container"}
  local -n pNameOfOutputVarFromCaller=${4?"Shell to use on connection to the container"}

  # generate id_rsa keypair
  #

  local -r _CMD_='
    rm -rvf ${HOME}/.ssh/id_rsa* >/dev/null || true
    ssh-keygen -f ${HOME}/.ssh/id_rsa -t rsa -b 2048 -q -N "" >/dev/null
    cat ${HOME}/.ssh/id_rsa.pub
  '

  local _CMD_OUTPUT=""
  fn__ExecCommandInContainerGetOutput \
    ${pClientContainerName} \
    ${pClientUsername} \
    ${pShellInContainer} \
    "${_CMD_}" \
    "pNameOfOutputVarFromCaller" \
      && STS=${__DONE} \
      || STS=${__FAILED}

    return ${STS}
}


function fn__GetSSHIdRsaPubKeyFromClientContainer() {
  local -r lUsage='
  Usage: 
    fn__GetSSHIdRsaPubKeyFromClientContainer \
      ${__GIT_CLIENT_CONTAINER_NAME} \
      ${__GIT_CLIENT_USERNAME} \
      ${__GIT_CLIENT_SHELL} \
      "__GIT_CLIENT_ID_RSA_PUB_" \
        && return ${__DONE} \
        || return ${__FAILED}
  '
  [[ $# -lt  4 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pClientContainerName=${1?"Container Name to be assigned to the container"}
  local -r pClientUsername=${2?"Host Path, in DOS format, to write shortcuts to"}
  local -r pShellInContainer=${3?"Shell to use on connection to the container"}
  local -n pNameOfOutputVarFromCaller=${4?"Shell to use on connection to the container"}

  # generate id_rsa keypair
  #

  local -r _CMD_='
    cat ${HOME}/.ssh/id_rsa.pub
  '

  local _CMD_OUTPUT=""
  fn__ExecCommandInContainerGetOutput \
    ${pClientContainerName} \
    ${pClientUsername} \
    ${pShellInContainer} \
    "${_CMD_}" \
    "pNameOfOutputVarFromCaller" \
      && STS=${__DONE} \
      || STS=${__FAILED}

    return ${STS}
}


function fn__IntroduceRemoteClientToServerWithPublicKey() {

  # introduce client's id_rsa public key to gitserver, which needs it to allow git test client access over ssh
  #
    local -r lUsage='
  Usage: 
    fn__IntroduceRemoteClientToServerWithPublicKey \
      ${__GIT_CLIENT_CONTAINER_NAME} \
      ${__GIT_CLIENT_USERNAME} \
      ${__GIT_CLIENT_ID_RSA_PUB_}  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
  [[ $# -lt 6 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pClientContainerName=${1?"${lUsage}"}
  local -r pClientUsername=${2?"${lUsage}"}
  local -r pClient_id_rsa_pub=${3?"${lUsage}"}
  local -r pServerContainerName=${4?"${lUsage}"}
  local -r pServerUsername=${5?"${lUsage}"}
  local -r pShellInContainer=${6?"${lUsage}"}

  # echo ".... ${FUNCNAME}:${LINENO}: pClientContainerName: ${pClientContainerName}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pClientUsername: ${pClientUsername}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pClient_id_rsa_pub: ${pClient_id_rsa_pub}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pServerContainerName: ${pServerContainerName}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pServerUsername: ${pServerUsername}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pShellInContainer: ${pShellInContainer}" >&2

  [[ -n ${pClientContainerName// /} ]] || { echo -e "____ Client Container Name must not be empty\n${lUsage}"; return ${__FAILED} ; }
  [[ -n ${pClientUsername// /} ]] || { echo -e "____ Client Username must not be empty\n${lUsage}"; return ${__FAILED} ; }
  [[ -n ${pClient_id_rsa_pub// /} ]] || { echo -e "____ Client id_rsa.pub public key must not be empty\n${lUsage}" && return ${__FAILED} ; }
  [[ -n ${pServerContainerName// /} ]] || { echo -e "____ Server Container Name must not be empty\n${lUsage}"; return ${__FAILED} ; }
  [[ -n ${pServerUsername// /} ]] || { echo -e "____ Server Username must not be empty\n${lUsage}"; return ${__FAILED} ; }
  [[ -n ${pShellInContainer// /} ]] || { echo -e "____ Server container shell must not be empty\n${lUsage}"; return ${__FAILED} ; }

  local -r lIdRsaPubTemplate="ssh-rsa ${pClientUsername}@${pClientContainerName}"
  local -r lIdRsaPubSignature="${pClient_id_rsa_pub%% *} ${pClient_id_rsa_pub##* }"
  [[ "${lIdRsaPubSignature}" != "${lIdRsaPubTemplate}" ]] && { echo "____ Client rsa public key invalid, or username or container name mismatch" && return ${__FAILED} ; }

  local -r _CMD_="
    { test -e \${HOME}/.ssh/authorized_keys \
      || touch \${HOME}/.ssh/authorized_keys ; } &&

    { mv \${HOME}/.ssh/authorized_keys ~/.ssh/authorized_keys_previous &&
    chmod 0600 \${HOME}/.ssh/authorized_keys_previous ; } &&

    { test -e \${HOME}/.ssh/authorized_keys \
      && cp \${HOME}/.ssh/authorized_keys \${HOME}/.ssh/authorized_keys_previous \
      || touch \${HOME}/.ssh/authorized_keys \${HOME}/.ssh/authorized_keys_previous ; } &&

    sed \"/${pClientUsername}@${pClientContainerName}/d\" \${HOME}/.ssh/authorized_keys_previous > \${HOME}/.ssh/authorized_keys &&

    echo "\"${pClient_id_rsa_pub}\"" >> \${HOME}/.ssh/authorized_keys &&

    cat \${HOME}/.ssh/authorized_keys
  "

  declare _CMD_OUTPUT_=""
  fn__ExecCommandInContainerGetOutput \
    ${pServerContainerName} \
    ${pServerUsername} \
    ${pShellInContainer} \
    "${_CMD_}" \
    "_CMD_OUTPUT_" \
      && STS=${__DONE} \
      || STS=${__FAILED}

  [[ ${STS} -ne ${__DONE} ]] && echo "${_CMD_OUTPUT_}"

  return ${STS}
}





function fn__GetSSHIdRsaPubKeyFromLocalWSLHost() {
  local -r lUsage='
  Usage: 
    fn__GetSSHIdRsaPubKeyFromLocalWSLHost \
      "__GIT_CLIENT_ID_RSA_PUB_" \
        && return ${__DONE} \
        || return ${__FAILED}
  '
  [[ $# -lt  1 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
 
  local -n pNameOfOutputVarFromCaller=${1?"${__INSUFFICIENT_ARGS}\n${lUsage}"}

  # get content of id_rsa.pub
  #
  pNameOfOutputVarFromCaller=$(cat ${HOME}/.ssh/id_rsa.pub) && STS=$? || STS=$?

  return ${STS}
}




function fn__GenerateSSHKeyPairInWSLHost() {
  local -r lUsage='
  Usage: 
    fn__GenerateSSHKeyPairInWSLHost \
      "__GIT_CLIENT_ID_RSA_PUB_" \
        && return ${__DONE} \
        || return ${__FAILED}
  '
  [[ $# -lt  1 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
 
  local -n pNameOfOutputVarFromCaller=${1?"output variable name"}

  ## del /f /q %HOMEPATH%\.ssh\id_rsa*
  ## ssh-keygen -f %HOMEPATH%\.ssh\id_rsa -t rsa -b 4096 -q -N ""

  # generate id_rsa keypair
  #
  TS=$(date '+%Y%m%d_%H%M%S')
  mv -f ${HOME}/.ssh/id_rsa.pub ${HOME}/.ssh/id_rsa.pub_${TS} || true
  mv -f ${HOME}/.ssh/id_rsa ${HOME}/.ssh/id_rsa_${TS} || true
  ssh-keygen -f ${HOME}/.ssh/id_rsa -t rsa -b 4096 -q -N "" >/dev/null && STS=$? || STS=$?
  pNameOfOutputVarFromCaller=$(cat ${HOME}/.ssh/id_rsa.pub) && STS=$? || STS=$?

  return ${STS}
}


function fn__IntroduceLocalWSLClientToServerWithPublicKey() {

  # introduce client's id_rsa public key to gitserver, which needs it to allow git test client access over ssh
  #
    local -r lUsage='
  Usage: 
    fn__IntroduceLocalWSLClientToServerWithPublicKey \
      ${__GIT_CLIENT_ID_RSA_PUB_}  \
      ${__GITSERVER_HOST_NAME} \
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
  local -r pServerHostName=${2?"${lUsage}"}
  local -r pServerUsername=${3?"${lUsage}"}
  local -r pShellInContainer=${4?"${lUsage}"}

  # echo ".... ${FUNCNAME}:${LINENO}: pClient_id_rsa_pub: ${pClient_id_rsa_pub}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pServerHostName: ${pServerHostName}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pServerUsername: ${pServerUsername}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pShellInContainer: ${pShellInContainer}" >&2

  [[ -n ${pClient_id_rsa_pub// /} ]] || { echo -e "____ Client id_rsa.pub public key must not be empty\n${lUsage}" && return ${__FAILED} ; }
  [[ -n ${pServerHostName// /} ]] || { echo -e "____ Server Host Name must not be empty\n${lUsage}"; return ${__FAILED} ; }
  [[ -n ${pServerUsername// /} ]] || { echo -e "____ Server Username must not be empty\n${lUsage}"; return ${__FAILED} ; }
  [[ -n ${pShellInContainer// /} ]] || { echo -e "____ Server Host shell must not be empty\n${lUsage}"; return ${__FAILED} ; }

  local -r lIdRsaPubTemplate="ssh-rsa ${USER}@${NAME}"
  local -r lIdRsaPubSignature="${pClient_id_rsa_pub%% *} ${pClient_id_rsa_pub##* }"
  [[ "${lIdRsaPubSignature}" != "${lIdRsaPubTemplate}" ]] && { echo "____ Client rsa public key invalid, or username or container name mismatch" && return ${__FAILED} ; }

  local -r _CMD_="
    { test -e \${HOME}/.ssh/authorized_keys \
      || touch \${HOME}/.ssh/authorized_keys ; } &&

    { mv \${HOME}/.ssh/authorized_keys ~/.ssh/authorized_keys_previous &&
    chmod 0600 \${HOME}/.ssh/authorized_keys_previous ; } &&

    { test -e \${HOME}/.ssh/authorized_keys \
      && cp \${HOME}/.ssh/authorized_keys \${HOME}/.ssh/authorized_keys_previous \
      || touch \${HOME}/.ssh/authorized_keys \${HOME}/.ssh/authorized_keys_previous ; } &&

    sed \"/${USER}@${NAME}/d\" \${HOME}/.ssh/authorized_keys_previous > \${HOME}/.ssh/authorized_keys &&

    echo "\"${pClient_id_rsa_pub}\"" >> \${HOME}/.ssh/authorized_keys &&

    cat \${HOME}/.ssh/authorized_keys
  "

  declare _CMD_OUTPUT_=""
  fn__ExecCommandInContainerGetOutput \
    ${pServerHostName} \
    ${pServerUsername} \
    ${pShellInContainer} \
    "${_CMD_}" \
    "_CMD_OUTPUT_" \
      && STS=${__DONE} \
      || STS=${__FAILED}

  [[ ${STS} -ne ${__DONE} ]] && {
    echo "${_CMD_OUTPUT_}"
    return ${STS}
  }

  _CMD_OUTPUT_2=""
  fn__GetWSLClientsPublicKeyFromServer \
    ${pServerHostName} \
    ${pServerUsername} \
    ${pShellInContainer} \
    "_CMD_OUTPUT_2" && STS=$? || STS=$?

  if [[ "${pClient_id_rsa_pub}" != "${_CMD_OUTPUT_2}" ]]
  then
    # echo "~~~~~~ ${FUNCNO}:${LINENO}: STS: ${STS}"
    # echo "~~~~~~ ${FUNCNO}:${LINENO}: pClient_id_rsa_pub: ${pClient_id_rsa_pub}"
    # echo "~~~~~~ ${FUNCNO}:${LINENO}: _CMD_OUTPUT_2: ${_CMD_OUTPUT_2}"
    echo "Failed to add/update Client Public Key in Server's ~/.ssh/authorized_hosts"
    return ${__FAILED}
  fi

  return ${STS}
}


function fn__GetWSLClientsPublicKeyFromServer() {

  local -r lUsage='
  Usage: 
    fn__GetWSLClientsPublicKeyFromServer \
      ${__GITSERVER_HOST_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
      "__GIT_CLIENT_ID_RSA_PUB_"  \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
  [[ $# -lt 4 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pServerHostName=${1?"${lUsage}"}
  local -r pServerUsername=${2?"${lUsage}"}
  local -r pShellInContainer=${3?"${lUsage}"}
  local -n pClient_id_rsa_pub=${4}

  # echo ".... ${FUNCNAME}:${LINENO}: pClient_id_rsa_pub: ${pClient_id_rsa_pub}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pServerHostName: ${pServerHostName}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pServerUsername: ${pServerUsername}" >&2
  # echo ".... ${FUNCNAME}:${LINENO}: pShellInContainer: ${pShellInContainer}" >&2

  [[ -n ${pServerHostName// /} ]] || { echo -e "____ Server Host Name must not be empty\n${lUsage}"; return ${__FAILED} ; }
  [[ -n ${pServerUsername// /} ]] || { echo -e "____ Server Username must not be empty\n${lUsage}"; return ${__FAILED} ; }
  [[ -n ${pShellInContainer// /} ]] || { echo -e "____ Server Host shell must not be empty\n${lUsage}"; return ${__FAILED} ; }

  local -r lClientIdRsaPubId="${USER}@${NAME}"

  local -r _CMD_="grep '${USER}@${NAME}' \${HOME}/.ssh/authorized_keys"
  # echo ".... ${FUNCNAME}:${LINENO}: _CMD_:${_CMD_}"

  declare _CMD_OUTPUT_=""
  fn__ExecCommandInContainerGetOutput \
    ${pServerHostName} \
    ${pServerUsername} \
    ${pShellInContainer} \
    "${_CMD_}" \
    "_CMD_OUTPUT_" \
      && STS=${__DONE} \
      || STS=${__FAILED}

  # echo ".... ${FUNCNAME}:${LINENO}: _CMD_OUTPUT_:${_CMD_OUTPUT_}"

  pClient_id_rsa_pub="${_CMD_OUTPUT_}"
  return ${STS}
}
