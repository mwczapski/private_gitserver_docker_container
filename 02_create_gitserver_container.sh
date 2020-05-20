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

[[ ${fn__WSLPathToDOSandWSDPaths} ]] || source ./utils/fn__WSLPathToDOSandWSDPaths.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh

[[ ${fn__CreateWindowsShortcut} ]] || source ./utils/fn__CreateWindowsShortcut.sh

[[ ${_02_create_gitserver_container_utils} ]] || source ./02_create_gitserver_container_utils.sh


:<<-'COMMENT-----------------------------------------------'

expect directory structure like
/mnt/x/dir1/dir2/..dirN/projectDir/_commonUtils/02_create_node13131_container
and working directory /mnt/x/dir1/dir2/..dirN/projectDir/_commonUtils

COMMENT-----------------------------------------------


## ##################################################################################
## ##################################################################################
##
## ##################################################################################
## ##################################################################################

# confirm project directory
# /mnt/x/dir1/dir2/..dirn/projectDir/_commonUtils/02_create_node13131_container
#
__DEBMIN_HOME=$(pwd)
readonly __CWD_NAME=$(basename ${__DEBMIN_HOME})
[[ "${__CWD_NAME}" == "_commonUtils" ]] || {
  echo "${0} must run from directory with name _commonUtils and will use the name of its parent directory as project directory"
  exit
}

declare __CONTAINER_SOURCE_IMAGE_NAME
declare __DEBMIN_HOME_WSD
declare __DEBMIN_HOME_DOS
declare __DOCKER_COMPOSE_FILE_WLS
declare __DOCKER_COMPOSE_FILE_DOS

fn__SetEnvironmentVariables \
  "${__DEBMIN_HOME}" \
  "${__GITSERVER_USERNAME}" \
  "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}" \
  "__DEBMIN_HOME" \
  "__DEBMIN_HOME_WSD" \
  "__DEBMIN_HOME_DOS" \
  "__DOCKER_COMPOSE_FILE_WLS" \
  "__DOCKER_COMPOSE_FILE_DOS" \
  "__CONTAINER_SOURCE_IMAGE_NAME" && STS=$? || STS=$?

case ${STS} in
  ${__SUCCESS})
    ;;
  ${__INSUFFICIENT_ARGS_STS})
    echo "${__INSUFFICIENT_ARGS}"
    echo "______ ${LINENO}: Aborting ..."
    exit ${STS}
    ;;
  ${__EMPTY_ARGUMENT_NOT_ALLOWED})
    echo "_error Empty arguments not allowed"
    echo "______ ${LINENO}: Aborting ..."
    exit ${STS}
    ;;
  ${__INVALID_VALUE})
    echo "_error Argument has invalid value"
    echo "______ ${LINENO}: Aborting ..."
    exit ${STS}
    ;;
  ${__NO_SUCH_DIRECTORY})
    echo "_error script not running from '${__SCRIPTS_DIRECTORY_NAME}'"
    echo "______ ${LINENO}: Aborting ..."
    exit ${STS}
    ;;
esac
echo "______ Set environment variables"; 


fn__ConfirmYN "Create Windows Shortcuts?" && _CREATE_WINDOWS_SHORTCUTS_=${__YES} || _CREATE_WINDOWS_SHORTCUTS_=${__NO}


fn__ConfirmYN "Artefact location will be ${__DEBMIN_HOME} - Is this correct?" && true || {
  echo -e "_______ Aborting ...\n"
  exit ${__NO}
}


# note that we are passing the name of the array of port mappings - the function deals with access to the array
#
fn__CreateDockerComposeFile \
  "${__GITSERVER_CONTAINER_NAME}"  \
  "${__GITSERVER_HOST_NAME}"  \
  "${__DEVCICD_NET}"  \
  "${__CONTAINER_SOURCE_IMAGE_NAME}"  \
  "__GITSERVER_PORT_MAPPINGS"  \
  "${__DEBMIN_HOME_WSD}/backups:${__GITSERVER_HOST_BACKUP_DIR}" \
  "${__DOCKER_COMPOSE_FILE_WLS}"


echo "______ Created ${__DOCKER_COMPOSE_FILE_WLS}"; 


fn__ImageExists \
  "${__CONTAINER_SOURCE_IMAGE_NAME}" \
  && echo "______ Image ${__CONTAINER_SOURCE_IMAGE_NAME} exist" \
  || {
    echo "repo: ${__DOCKER_REPOSITORY_HOST}/${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"
    fn__PullImageFromRemoteRepository   \
      ${__DOCKER_REPOSITORY_HOST}  \
      ${__GITSERVER_IMAGE_NAME} \
      ${__GITSERVER_IMAGE_VERSION} \
        && echo "______ Image ${__DOCKER_REPOSITORY_HOST}/${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} pulled from remote docker repository" \
        || {
          echo "______ Cannot find image ${__CONTAINER_SOURCE_IMAGE_NAME} [${__DOCKER_REPOSITORY_HOST}/${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}]" 
          echo "______ Aborting script execution ..." 
          exit ${__FAILED}
        }
  }


fn__ContainerExists \
  ${__GITSERVER_CONTAINER_NAME} \
    && STS=${__YES} \
    || STS=${__NO}
    
if [[ $STS -eq ${__YES} ]]; then

  fn__ContainerIsRunning ${__GITSERVER_CONTAINER_NAME} && STS=${__YES} || STS=${__NO}
  if [[ $STS -eq ${__YES} ]]; then

    echo "______ Container ${__GITSERVER_CONTAINER_NAME} Exist and is running ... - nothing needs doing"; 

  else
    fn__StartContainer ${__GITSERVER_CONTAINER_NAME} && STS=${__YES} || STS=${__NO}
    if [[ $STS -eq ${__DONE} ]]; then
        echo "______ Container ${__GITSERVER_CONTAINER_NAME} started"; 
    else
        echo "______ Failed to start container ${__GITSERVER_CONTAINER_NAME} - investigate..."; 
        exit ${__FAILED}
    fi
  fi

else
  
  fn_DockerComposeUpDetached "${__DOCKER_COMPOSE_FILE_DOS}" "${__GITSERVER_CONTAINER_NAME}" && STS=${__DONE} || STS=${__FAILED}
  if [[ $STS -eq ${__DONE} ]]; then
    echo "______ Container ${__GITSERVER_CONTAINER_NAME} started"; 
  else
    echo "______ Failed to start container ${__GITSERVER_CONTAINER_NAME} - investigate"; 
    exit ${__FAILED}
  fi
fi

[[ ${_CREATE_WINDOWS_SHORTCUTS_} -eq ${__YES} ]] && {
  fn__CreateWindowsShortcutsForShellInContainer \
    "${__GITSERVER_CONTAINER_NAME}" \
    "${__DEBMIN_HOME_DOS}" \
    "${__GITSERVER_SHELL}" \
    "${__DOCKER_COMPOSE_FILE_DOS}" && STS=${__DONE} || STS=${__FAILED}
  echo "______ Created Windows Shortcuts"; 
}

echo "______ Container ${__GITSERVER_CONTAINER_NAME} is running"; 

echo "______ ${0} Done"

exit ${__SUCCESS}
