#!/bin/bash

###############################################
## The MIT License (MIT)
##
## Copyright © 2020 Michael Czapski
###############################################

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
[[ ${__env_gitClientConstants} ]] || source ./utils/__env_gitClientConstants.sh
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
[[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh
[[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh

[[ ${fn__CreateWindowsShortcut} ]] || source ./utils/fn__CreateWindowsShortcut.sh


[[ ${_01_create_gitserver_image_utils} ]] || source ./01_create_gitserver_image_utils.sh


## ##################################################################################
## ##################################################################################
## 
## ##################################################################################
## ##################################################################################

function execute_01_create_gitserver_image() {

  fn__ConfirmYN "Push generated Docker Image to the remote docker repository?" && STS=${__YES} || STS=${__NO}
  readonly __PUSH_TO_REMOTE_DOCKER_REPO=$STS

  echo "____ Push of the image to the remote Docker repository has $([[ ${__PUSH_TO_REMOTE_DOCKER_REPO} -eq ${__NO} ]] && echo "NOT ")been requested."

  # confirm working directory
  #
  __DEBMIN_HOME=$(pwd | sed 's|/_commonUtils||')

  fn__ConfirmYN "Artefacts location will be ${__DEBMIN_HOME} - Is this correct?" && true || {
    echo "_____ Aborting ..."
    exit
  }


  fn__SetEnvironmentVariables \
    "${__SCRIPTS_DIRECTORY_NAME}" \
    "${__GITSERVER_IMAGE_NAME}"  \
    "${__GITSERVER_SHELL_GLOBAL_PROFILE}"  \
    "__DEBMIN_HOME"  \
    "__DEBMIN_HOME_DOS"  \
    "__DEBMIN_HOME_WSD" \
    "__DOCKERFILE_PATH"  \
    "__REMOVE_CONTAINER_ON_STOP"  \
    "__NEEDS_REBUILDING" ## && STS=${__SUCCESS} || STS=${__FAILED} # let it abort if failed and investigate
  echo "_____ Set environment variables" 


  fn__Create_docker_entry_point_file \
    ${__DEBMIN_HOME}  \
    ${__GITSERVER_SHELL}  \
      && STS=${__SUCCESS} \
      || STS=${__INSUFFICIENT_ARGS_STS} ## && STS=${__SUCCESS} || STS=${__INSUFFICIENT_ARGS_STS} #  # let it abort if failed and investigate
  echo "_____ Created docker-entrypoint.sh" 


  fn__CreateDockerfile \
    "${__DEBMIN_SOURCE_IMAGE_NAME}" \
    "${__GIT_USERNAME}" \
    "${__GITSERVER_SHELL}"  \
    "${__GITSERVER_SHELL_PROFILE}"  \
    "${__TZ_PATH}"  \
    "${__TZ_NAME}"  \
    "${__GITSERVER_SHELL_GLOBAL_PROFILE}"  \
    "${__GITSERVER_REPOS_ROOT}" \
    "${__DOCKERFILE_PATH}"  \
    "${__NEEDS_REBUILDING}" && STS=$? || STS=$?

    case ${STS} in
      ${__YES})
        __REBUILD_IMAGE=${__YES}
        ;;
      ${__NO}) 
        __REBUILD_IMAGE=${__NO}
        ;;
      ${__INSUFFICIENT_ARGS_STS})
        echo "${__INSUFFICIENT_ARGS}"
        echo "____ ${LINENO}: Aborting ..."
        exit ${STS}
        ;;
      ${__EMPTY_ARGUMENT_NOT_ALLOWED})
        echo "_error Empty arguments not allowed"
        echo "____ ${LINENO}: Aborting ..."
        exit ${STS}
        ;;
      ${__INVALID_VALUE})
        echo "_error Argument has invalid value"
        echo "____ ${LINENO}: Aborting ..."
        exit ${STS}
        ;;
    esac
  echo "_____ Created Dockerfile: ${__DOCKERFILE_PATH}" 


  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


  fn__ImageExists \
    "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}" &&
      __IMAGE_EXISTS=${__YES} || 
      __IMAGE_EXISTS=${__NO}
  [[ ${__IMAGE_EXISTS} -eq ${__NO} ]]  \
    && {
      echo "_____ Image ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} does not exist"
      __REBUILD_IMAGE=${__YES}
    } \
    || echo "_____ Image ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} exists"


  if [[ ${__REBUILD_IMAGE} -eq ${__YES} ]]; then
    fn__BuildImage  \
      ${__REBUILD_IMAGE} \
      ${__GITSERVER_IMAGE_NAME} \
      ${__GITSERVER_IMAGE_VERSION} \
      ${__DEBMIN_HOME_DOS}/Dockerfile.${__GITSERVER_IMAGE_NAME} \
      ${__DEVCICD_NET} ## && STS=${__SUCCESS} || STS=${__FAILED} # let it abort if failed
    echo "_____ Image ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} (re-)built"
  fi


  fn__ContainerExists \
    ${__GITSERVER_CONTAINER_NAME} \
      && STS=${__YES} \
      || STS=${__NO}

  if [[ $STS -eq ${__YES} ]]; then
    echo "_____ Container ${__GITSERVER_CONTAINER_NAME} exists - will stopp and remove"
    fn__StopAndRemoveContainer  ${__GITSERVER_CONTAINER_NAME} && STS=${__YES} || STS=${__NO}
    echo "_____ Container ${__GITSERVER_CONTAINER_NAME} stopped and removed"
  else
    echo "_____ Container ${__GITSERVER_CONTAINER_NAME} does not exist"
  fi


  fn__RunContainerDetached \
    ${__GITSERVER_IMAGE_NAME} \
    ${__GITSERVER_IMAGE_VERSION} \
    ${__GITSERVER_CONTAINER_NAME} \
    ${__GITSERVER_HOST_NAME} \
    ${__REMOVE_CONTAINER_ON_STOP} \
    ${__EMPTY} \
    ${__DEVCICD_NET} \
      && STS=${__DONE} || \
      STS=${__FAILED}
  echo "_____ Container ${__GITSERVER_CONTAINER_NAME} started"


  if [[ $STS -eq ${__DONE} ]]; then

    fn__UpdateOwnershipOfNonRootUserResources  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_GUEST_HOME}  \
      ${__GITSERVER_SHELL}  \
      ${__GITSERVER_REPOS_ROOT} && STS=$? || STS=$?
      echo "_____ Updated ownership of resources for user ${__GIT_USERNAME}"


    fn__MakeCustomGitShellCommandsDirectory \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
        && {

          fn__CreateCustomGitShellCommandsAndCopyToServer \
            ${__GITSERVER_CONTAINER_NAME} \
            ${__GIT_USERNAME} \
            ${__GITSERVER_SHELL} \
            ${__DEBMIN_HOME_DOS}  \
            ${__DEBMIN_HOME}  \
              && {
                echo "____ Created Custom Git Shell Commands"; 
              } \
              || STS=${__FAILED}
        } \
        || STS=${__FAILED}


    fn__CommitChangesStopContainerAndSaveImage   \
      "${__GITSERVER_CONTAINER_NAME}" \
      "${__GITSERVER_IMAGE_NAME}" \
      "${__GITSERVER_IMAGE_VERSION}"
    echo "_____ Commited changes to ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} and Stopped container ${__CONTAINER_NAME}"


    if [[ ${__PUSH_TO_REMOTE_DOCKER_REPO} == ${__YES} ]]; then

      fn__PushImageToRemoteRepository   \
        "${__DOCKER_REPOSITORY_HOST}"  \
        "${__GITSERVER_IMAGE_NAME}" \
        "${__GITSERVER_IMAGE_VERSION}"
      echo "_____ Image tagged and pushed to repository as ${__DOCKER_REPOSITORY_HOST}/${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}" 
    else
      echo "_____ On user request on user request image ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} has NOT been pushed to Docker repository ${__DOCKER_REPOSITORY_HOST}" 
    fi


  else
    ${__INDUCE_ERROR}
  fi

  echo "Done..."
}

execute_01_create_gitserver_image    ## execute main function
