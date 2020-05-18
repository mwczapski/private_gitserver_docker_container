# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__DockerGeneric="SOURCED"

readonly __DOCKER_NO_EXT="docker"
readonly __DOCKER_EXE="docker.exe"
readonly __DOCKER_COMPOSE_NO_EXT="docker-compose"
readonly __DOCKER_COMPOSE_EXE="docker-compose.exe"

readonly __DOCKER_REPOSITORY_HOST="mcz11.czapski.id.au"

[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh

:<<-'EXAMPLE----------------------------------------------------------'
      __CONTAINER_NAME="node13130"
      __HOST_NAME=${__CONTAINER_NAME}
      fn__RunContainerDetached \
          "${__DEBMIN_NEW_IMAGE_NAME}" \
          "${__DEBMIN_NEW_IMAGE_VERSION}" \
          "${__CONTAINER_NAME}" \
          "${__HOST_NAME}" \
          "${__REMOVE_CONTAINER_ON_STOP}" \
          "${__CONTAINER_MAPPED_PORTS}" \
          "${__DEBMIN_NET}" && STS=$? || STS=$?
EXAMPLE----------------------------------------------------------

function fn__RunContainerDetached() {
  local pImageName=${1?"Usage: ${0}:${FUNCNAME} requires image name as 1st argument"}
  local pImageVersion=${2?"Usage: ${0}:${FUNCNAME} requires image version as 2nd argument"}
  local pContainerName=${3?"Usage: ${0}:${FUNCNAME} requires Container Name as 3rd argument"}
  local pHostName=${4?"Usage: ${0}:${FUNCNAME} requires Host Name as 4th argument"}
  local pRemoveOnStop=${5?"Usage: ${0}:${FUNCNAME} requires 0 (Yes) or 1 (No) as Remove-on-Stop as 5th argument"}
  local pContainerMappedPorts=${6?"Usage: ${0}:${FUNCNAME} requires a valid 'container mapped local ports' expression as 6th argument"}
  local pNetworkName=${7?"Usage: ${0}:${FUNCNAME} requires a valid network name as 7th argument"}

  [[ ${pContainerMappedPorts} == ${__EMPTY} ]] && pContainerMappedPorts=""

  pRemoveOnStop=$(tr '[a-z]' '[A-Z]' <<<${pRemoveOnStop:0:1})
  [[ $pRemoveOnStop == ${__YES} ]] && REMOVE_ON_STOP='--rm' || REMOVE_ON_STOP=''

  ${__DOCKER_EXE} run \
    ${REMOVE_ON_STOP} \
    ${pContainerMappedPorts} \
    --publish-all \
    --network="${pNetworkName}" \
    -it \
    --hostname "${pHostName}" \
    --name "${pContainerName}" \
    --detach \
      ${pImageName}:${pImageVersion} && return ${__SUCCESS} || return ${__FAILED}
}

:<<-'EXAMPLE----------------------------------------------------------'
fn__ContainerExists ${__CONTAINER_NAME} && STS=0 || STS=1
if [[ $STS -eq 0 ]]; then

    echo "______ Container ${__CONTAINER_NAME} Exist - will start it"; 
    fn__StartContainer ${__CONTAINER_NAME} && STS=0 || STS=1

    if [[ $STS -eq 0 ]]; then
        echo "______ Container ${__CONTAINER_NAME} started"; 
    else
        echo "______ Failed to start container ${__CONTAINER_NAME} - investigate..."; 
        exit;
    fi
fi
EXAMPLE----------------------------------------------------------

function fn__ContainerExists() {
  local pContainerName=${1?"Usage: ${0}:${FUNCNAME} requires Container Name as 1st argument"}
  ${__DOCKER_EXE} container ls -a | grep ${pContainerName} > /dev/null && return ${__YES} || return ${__NO}
  return ${__NO}
}

function fn__ContainerIsRunning() {
  local pContainerName=${1?"Usage: ${0}:${FUNCNAME} requires Container Name as 1st argument"}
  # ${__DOCKER_EXE} container ls | grep ${pContainerName} >/dev/null && return 0 || return 1
  ${__DOCKER_EXE} container ls | grep ${pContainerName} >/dev/null && return ${__YES} || return ${__NO}
}

function fn__StartContainer() {
  local pContainerName=${1?"Usage: ${0}:${FUNCNAME} requires Container Name as 1st argument"}
  ${__DOCKER_EXE} container start ${pContainerName} >/dev/null && return ${__SUCCESS} || return ${__FAILED}
}

:<<-'EXAMPLE----------------------------------------------------------'
  fn__StopAndRemoveContainer  ${__CONTAINER_NAME}
EXAMPLE----------------------------------------------------------

function fn__StopAndRemoveContainer() {
  local pContainerName=${1?"Usage: ${0}:${FUNCNAME} requires Container Name as 1st argument"}
  fn__ContainerExists ${pContainerName} || return ${__SUCCESS}
  ${__DOCKER_EXE} container stop ${pContainerName} || return ${__FAILED}
  fn__ContainerExists ${pContainerName} || return ${__SUCCESS}
  ${__DOCKER_EXE} container rm ${pContainerName} && return ${__SUCCESS} || return ${__FAILED}
}

:<<-'EXAMPLE----------------------------------------------------------'
      fn__CommitStopTagAndPushImageToRemoteRepository   \
        "${__CONTAINER_NAME}" \
        "${__DOCKER_REPOSITORY_HOST}"  \
        "${__DEBMIN_NEW_IMAGE_NAME}" \
        "${__DEBMIN_NEW_IMAGE_VERSION}"
EXAMPLE----------------------------------------------------------

function fn__CommitStopTagAndPushImageToRemoteRepository() {
  local pContainerName=${1?"Usage: ${0}:${FUNCNAME} requires Container Name as 1st argument"}
  local pDockerRepoHost=${2?"Usage: ${0}:${FUNCNAME} requires Docker Repository Host name as 2nd argument"}
  local pNewImageName=${3?"Usage: ${0}:${FUNCNAME} requires New Image Name as 3rd argument"}
  local pNewImageVersion=${4?"Usage: ${0}:${FUNCNAME} requires New Image Version as 4th argument"}

  ${__DOCKER_EXE} commit ${pContainerName} ${pNewImageName}:${pNewImageVersion} 2>/dev/null || ${__IGNORE_ERROR}
  ${__DOCKER_EXE} stop ${pContainerName} 2>/dev/null || ${__IGNORE_ERROR}
  ${__DOCKER_EXE} tag ${pNewImageName}:${pNewImageVersion} ${pDockerRepoHost}/${pNewImageName}:${pNewImageVersion}
  ${__DOCKER_EXE} push ${pDockerRepoHost}/${pNewImageName}:${pNewImageVersion}
  return ${__SUCCESS}
}


:<<-'EXAMPLE----------------------------------------------------------'
      fn__PushImageToRemoteRepository   \
        "${__DOCKER_REPOSITORY_HOST}"  \
        "${__DEBMIN_NEW_IMAGE_NAME}" \
        "${__DEBMIN_NEW_IMAGE_VERSION}"
EXAMPLE----------------------------------------------------------
function fn__PushImageToRemoteRepository() {
  local pDockerRepoHost=${1?"Usage: ${0}:${FUNCNAME} requires Docker Repository Host name as 2nd argument"}
  local pNewImageName=${2?"Usage: ${0}:${FUNCNAME} requires New Image Name as 3rd argument"}
  local pNewImageVersion=${3?"Usage: ${0}:${FUNCNAME} requires New Image Version as 4th argument"}

  ${__DOCKER_EXE} tag ${pNewImageName}:${pNewImageVersion} ${pDockerRepoHost}/${pNewImageName}:${pNewImageVersion}
  ${__DOCKER_EXE} push ${pDockerRepoHost}/${pNewImageName}:${pNewImageVersion}
  return ${__SUCCESS}
}


function fn__PullImageFromRemoteRepository() {
  local lUsage='
  Usage:
    fn__PullImageFromRemoteRepository   \
      "${__DOCKER_REPOSITORY_HOST}"  \
      "${__DEBMIN_NEW_IMAGE_NAME}" \
      "${__DEBMIN_NEW_IMAGE_VERSION}" \
        && STS=${__SUCCESS} \
        || STS=${__FAILED}
    '
  local pDockerRepoHost=${1?"${lUsage}"}
  local pImageName=${2?"${lUsage}"}
  local pImageVersion=${3?"${lUsage}"}

  ${__DOCKER_EXE} pull ${pDockerRepoHost}/${pImageName}:${pImageVersion} && STS=${__SUCCESS} || return ${__FAILED}
  ${__DOCKER_EXE} tag ${pDockerRepoHost}/${pImageName}:${pImageVersion} ${pImageName}:${pImageVersion} || return ${__FAILED}
  return ${__SUCCESS}
}


:<<-'EXAMPLE----------------------------------------------------------'
      fn__CommitChangesStopContainerAndSaveImage   \
        "${__CONTAINER_NAME}" \
        "${__DEBMIN_NEW_IMAGE_NAME}" \
        "${__DEBMIN_NEW_IMAGE_VERSION}"
EXAMPLE----------------------------------------------------------
function fn__CommitChangesStopContainerAndSaveImage() {
  local pContainerName=${1?"Usage: ${0}:${FUNCNAME} requires Container Name as 1st argument"}
  local pNewImageName=${2?"Usage: ${0}:${FUNCNAME} requires New Image Name as 3rd argument"}
  local pNewImageVersion=${3?"Usage: ${0}:${FUNCNAME} requires New Image Version as 4th argument"}

  ${__DOCKER_EXE} commit ${pContainerName} ${pNewImageName}:${pNewImageVersion} 2>/dev/null || ${__IGNORE_ERROR}
  ${__DOCKER_EXE} stop ${pContainerName} 2>/dev/null || ${__IGNORE_ERROR}
  return ${__SUCCESS}
}


:<<-'EXAMPLE----------------------------------------------------------'
  fn__BuildImage  \
    "${__REBUILD_IMAGE}" \
    "${__DEBMIN_IMAGE_NAME}" \
    "${__DEBMIN_IMAGE_VERSION}" \
    "${__DEBMIN_HOME_DOS}/Dockerfile.${__DEBMIN_IMAGE_NAME}" \
    "${__DEBMIN_NET}"
EXAMPLE----------------------------------------------------------

function fn__BuildImage() {
  local pRebuildImage=${1?"Usage: ${0}:${FUNCNAME} requires 0 (Yes) or 1 (No) as Rebuild-Image indicator as 3rd argument"}
  local pNewImageName=${2?"Usage: ${0}:${FUNCNAME} requires New Image Name as 2nd argument"}
  local pNewImageVersion=${3?"Usage: ${0}:${FUNCNAME} requires New Image Version as 3rd argument"}
  local pDockerfileDosPath=${4?"Usage: ${0}:${FUNCNAME} requires full dos local  ath to the Dockerfile as 4th argument"}
  local pNetworkName=${5?"Usage: ${0}:${FUNCNAME} requires a valid network name as 5th argument"}

  if [[ $pRebuildImage == ${__YES} ]]; then
      # ${DEBMIN_ADDHOSTS} \
    ${__DOCKER_EXE} build \
      --tag ${pNewImageName}:${pNewImageVersion} \
      --file ${pDockerfileDosPath} \
      --network=${pNetworkName} \
      --force-rm \
      . \
        | tee ./${pNewImageName}_${pNewImageVersion}_image_build_$(date "+%F_%T").log
  fi
}

:<<-'EXAMPLE----------------------------------------------------------'
  fn__ImageExists  \
    "${__DEBMIN_IMAGE_NAME}:${__DEBMIN_IMAGE_VERSION}" && STS=$? || STS=$?
EXAMPLE----------------------------------------------------------

function fn__ImageExists() {
  local pImageName=${1?"Usage: ${0}:${FUNCNAME} requires full Image Name with Repository, if any, and Tag, if any as 1st argument"}
  local lPattern=${pImageName/:/[ ]*}
  # echo "pImageName: ${pImageName}"
  # echo "lPattern: ${lPattern}"
  local STS=${__YES}
  ${__DOCKER_EXE} image ls | grep "^${lPattern}" >/dev/null  && STS=${__YES} || STS=${__NO}
  # echo "STS: ${STS}"
  return ${STS}
}


:<<-'EXAMPLE----------------------------------------------------------'
 fn_DockerComposeUpDetached ${__DOCKER_COMPOSE_FILE} ${__CONTAINER_NAME_WLS} && STS=${__DONE} || STS=${__FAILED}
EXAMPLE----------------------------------------------------------
function fn_DockerComposeUpDetached() {
  local pDockerComposeFilePath=${1?"Usage: ${0}:${FUNCNAME} requires full DOS Path to docker-compose file"}
  local pContainerName=${2?"Usage: ${0}:${FUNCNAME} requires Container Name, which is the same as Service Name which to start"}
  ${__DOCKER_COMPOSE_EXE} \
    -f "${pDockerComposeFilePath}" \
    up \
    --detach \
      ${pContainerName} \
        && return ${__DONE} \
        || return ${__FAILED}
} 


:<<-'EXAMPLE----------------------------------------------------------'
__DCUP_CMD=$(fn_GetDockerComposeDOSCommandLine ${__DOCKER_COMPOSE_FILE_WLS} ${__CONTAINER_NAME} ${__DOCKER_COMPOSE_COMMAMND}" )
EXAMPLE----------------------------------------------------------
function fn_GetDockerComposeDOSCommandLine() {
  local pDockerComposeFilePath=${1?"Usage: ${0}:${FUNCNAME} requires full DOS Path to docker-compose file"}
  local pContainerName=${2?"Usage: ${0}:${FUNCNAME} requires Container Name, which is the same as Service Name which to start"}
  local pDockerComposeCommand=${3?"Usage: ${0}:${FUNCNAME} requires docker-compose command to issue to ${pContainerName}"}
  echo ${__DOCKER_COMPOSE_EXE} -f ${pDockerComposeFilePath} ${pDockerComposeCommand} ${pContainerName}
  return ${__DONE}
} 


# :<<-'EXAMPLE----------------------------------------------------------'
#   # Y or P is __YES, anything else, including nothing if default of __NO
#   [[ fn__PushToRemoteDockerRepo ${1} ]] && __PUSH2REMOTEREPO=${__YES} || __PUSH2REMOTEREPO=${__NO} 
# EXAMPLE----------------------------------------------------------
# function fn__PushToRemoteDockerRepo() {

#   local pPushToRepoBool=${__NO}
#   local pPushToRepoSt=${1:-NO}
#   if [[ $# -gt 0 ]]; then
#     pPushToRepoSt=${pPushToRepoSt^^}
#     pPushToRepoSt=${pPushToRepoSt:0:1}
#     case "${pPushToRepoSt}" in
#     Y|P) 
#       pPushToRepoBool=${__YES}
#       ;;
#     *) {
#       pPushToRepoBool=${__NO}
#     }
#     esac
#   fi
#   return ${pPushToRepoBool}
# }


function fn__DockerNetworkExists() {
  local lUsage='
  Usage:
    fn__DockerNetworkExists \
      ${__DEVCICD_NET} \
        && STS=${__YES} \
        || STS=${__NO}
    '
  local pDockerNet=${1?"${lUsage}"}

  ${__DOCKER_EXE} network ls | grep ${pDockerNet} >/dev/null && STS=${__YES} || STS=${__NO}
  return ${STS}
}


function fn__CreateDockerNetwork() {
  local lUsage='
  Usage:
    fn__CreateDockerNetwork \
      ${__DEVCICD_NET} \
      ${__DEVCICD_SUBNET_ADDRESS} \
      ${__DEVCICD_SUBNET_GATEWAY} \
        && STS=${__YES} \
        || STS=${__NO}
    '
  local pDockerNet=${1?"${lUsage}"}
  local pDockerSubnetAddress=${2?"${lUsage}"}
  local pDockerSubnetGateway=${3?"${lUsage}"}

  ${DOCKER_EXE} network \
    create \
    --attachable \
    ${__DEVCICD_NET} \
    --subnet ${__DEVCICD_SUBNET_ADDRESS} \
    --gateway ${__DEVCICD_SUBNET_GATEWAY} \
        && STS=${__YES} \
        || STS=${__NO}
  return ${STS}
}


function fn__ExecCommandInContainer() {

  local lUsage='
  Usage:
    fn__ExecCommandInContainer \
      ${__CONTAINER_NAME} \
      ${__CONTAINER_USERNAME} \
      ${__CONTAINER_SHELL} \
      ${__CONATINER_COMMAND} \
        && STS=${__DONE} \
        || STS=${__FAILED}
    '
  local pContainerName=${1?"${lUsage}"}
  local pContainerUsername=${2?"${lUsage}"}
  local pContainerShell=${3?"${lUsage}"}
  local pContainerCommand=${4?"${lUsage}"}

  # ${__DOCKER_EXE} exec -itu ${pContainerUsername} ${pContainerName} ${pContainerShell} -c "${pContainerCommand}" 2>/dev/null && STS=$? || STS=$?
  ${__DOCKER_EXE} exec -itu ${pContainerUsername} ${pContainerName} ${pContainerShell} -c "${pContainerCommand}" && STS=$? || STS=$?
  [[ ${STS} -eq ${__SUCCESS} ]] && STS=${__DONE}|| STS=${__FAILED}

  return ${STS}
}



function fn__ExecCommandInContainerGetOutput() {

  local lUsage='
  Usage:
    fn__ExecCommandInContainerGetOutput \
      ${__CONTAINER_NAME} \
      ${__CONTAINER_USERNAME} \
      ${__CONTAINER_SHELL} \
      ${__CONATINER_COMMAND} \
      "_OUTPUT_CAPTURE_VAR_NAME" \
        && STS=${__DONE} \
        || STS=${__FAILED}
    '
  local pContainerName=${1?"${lUsage}"}
  local pContainerUsername=${2?"${lUsage}"}
  local pContainerShell=${3?"${lUsage}"}
  local pContainerCommand=${4?"${lUsage}"}
  local -n pOutputCaptureVarName=${5?"${lUsage}"}

  pOutputCaptureVarName=$( ${__DOCKER_EXE} exec -u ${pContainerUsername} ${pContainerName} ${pContainerShell} -lc "${pContainerCommand}" 2>&1 )  && STS=$? || STS=$?
  [[ ${STS} -eq 0 ]] && STS=${__DONE}|| STS=${__FAILED}
  return ${STS}
}



function fn__CopyFileFromHostToContainer() {
  local lUsage='
  Usage:
    fn__CopyFileFromHostToContainer \
      ${__CONTAINER_NAME} \
      ${__LOCAL_FILE_PATH} \
      ${__REMOTE_FILE_PATH} \
        && STS=${__DONE} \
        || STS=${__FAILED}
    '
  local pContainerName=${1?"${lUsage}"}
  local pLocalFilePath=${2?"${lUsage}"}
  local pRemoteFilePath=${3?"${lUsage}"}

  ${__DOCKER_EXE} cp ${pLocalFilePath} ${pContainerName}:${pRemoteFilePath} &&  STS=${?} || STS=${?}
 
  return ${STS}
}