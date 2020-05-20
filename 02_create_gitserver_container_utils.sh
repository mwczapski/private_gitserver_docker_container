#!/bin/bash
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -ur _02_create_gitserver_container_utils="SOURCED"

# common environment variable values and utility functions
#
[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh
[[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
[[ ${fn__WSLPathToDOSandWSDPaths} ]] || source ./utils/fn__WSLPathToDOSandWSDPaths.sh

## ############################################################
## functions specific to 02_create_gitserver_container.sh
## ############################################################



function fn__CreateWindowsShortcutsForShellInContainer() {
    local lUsage='
      Usage: 
        fn__CreateWindowsShortcutsForShellInContainer \
          "${__GITSERVER_CONTAINER_NAME}" \
          "${__DEBMIN_HOME_DOS}" \
          "${__GITSERVER_SHELL}" \
          "${__DOCKER_COMPOSE_FILE_DOS}" && STS=${__DONE} || STS=${__FAILED}
      '
  [[ $# -lt  3 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pContainerName=${1?"Container Name to be assigned to the container"}
  local -r pHomeDosPath=${2?"Host Path, in DOS format, to write shortcuts to"}
  local -r pShellInContainer=${3?"Shell to use on connection to the container"}
  local -r pDockerComposeFileDos=${4?"Full DOS path to docker-compose.yml_XXX file "}

  local lDockerComposeCommand=""
  local lARGS=""
  local lDockerContainerCommandLine=""

  # create windows shortcuts for shell in container

  lARGS="/c wsl -d Debian -- bash -lc \"docker.exe container exec -itu ${__GIT_USERNAME} --workdir ${__GITSERVER_GUEST_HOME} ${pContainerName} ${pShellInContainer} -l\" || pause"
  fn__CreateWindowsShortcut \
    "${pHomeDosPath}\dcc exec -itu ${__GIT_USERNAME} ${pContainerName}.lnk" \
    "C:\Windows\System32\cmd.exe" \
    "%~dp0" \
    "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
    "C:\Windows\System32\wsl.exe" \
    "${lARGS}"

  lARGS="/c wsl -d Debian -- bash -lc \"docker.exe container exec -itu root --workdir / ${pContainerName} ${pShellInContainer} -l\" || pause"
  fn__CreateWindowsShortcut \
    "${pHomeDosPath}\dcc exec -itu root ${pContainerName}.lnk" \
    "C:\Windows\System32\cmd.exe" \
    "%~dp0" \
    "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
    "C:\Windows\System32\wsl.exe" \
    "${lARGS}"

  lDockerComposeCommand="up --detach"
  lDockerContainerCommandLine=$(fn_GetDockerComposeDOSCommandLine \
    "${pDockerComposeFileDos}" \
    "${pContainerName}" \
    "${lDockerComposeCommand}"
    )
  lARGS="/c ${lDockerContainerCommandLine} || pause"
  fn__CreateWindowsShortcut \
    "${pHomeDosPath}\\dco ${pContainerName} ${lDockerComposeCommand}.lnk" \
    "C:\Windows\System32\cmd.exe" \
    "%~dp0" \
    "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
    "C:\Program Files\Docker\Docker\resources\bin\docker.exe" \
    "${lARGS}"


  lDockerComposeCommand="stop"
  lDockerContainerCommandLine=$(fn_GetDockerComposeDOSCommandLine \
    "${pDockerComposeFileDos}" \
    "${pContainerName}" \
    "${lDockerComposeCommand}"
    )
  lARGS="/c ${lDockerContainerCommandLine} || pause"
  fn__CreateWindowsShortcut \
    "${pHomeDosPath}\\dco ${pContainerName} ${lDockerComposeCommand}.lnk" \
    "C:\Windows\System32\cmd.exe" \
    "%~dp0" \
    "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
    "C:\Program Files\Docker\Docker\resources\bin\docker.exe" \
    "${lARGS}"


  lDockerComposeCommand="ps"
  lDockerContainerCommandLine=$(fn_GetDockerComposeDOSCommandLine \
    "${pDockerComposeFileDos}" \
    "${pContainerName}" \
    "${lDockerComposeCommand}"
    )
  lARGS="/c ${lDockerContainerCommandLine} && pause"
  fn__CreateWindowsShortcut \
    "${pHomeDosPath}\\dco ${pContainerName} ${lDockerComposeCommand}.lnk" \
    "C:\Windows\System32\cmd.exe" \
    "%~dp0" \
    "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
    "C:\Program Files\Docker\Docker\resources\bin\docker.exe" \
    "${lARGS}"


  lDockerComposeCommand="rm -s -v"
  lDockerContainerCommandLine=$(fn_GetDockerComposeDOSCommandLine \
    "${pDockerComposeFileDos}" \
    "${pContainerName}" \
    "${lDockerComposeCommand}"
    )
  lARGS="/c ${lDockerContainerCommandLine} || pause"
  fn__CreateWindowsShortcut \
    "${pHomeDosPath}\\dco ${pContainerName} ${lDockerComposeCommand}.lnk" \
    "C:\Windows\System32\cmd.exe" \
    "%~dp0" \
    "${fn__CreateWindowsShortcut__RUN_NORMAL_WINDOW}" \
    "C:\Program Files\Docker\Docker\resources\bin\docker.exe" \
    "${lARGS}"


  return ${__DONE}
}


:<<-'COMMENT--fn__CreateDockerComposeFile-----------------------------------------'
  Usage: 
      fn__CreateDockerComposeFile \
        "${__GITSERVER_CONTAINER_NAME}"  \
        "${__GITSERVER_HOST_NAME}"  \
        "${__DEVCICD_NET}"  \
        "${__DEBMIN_SOURCE_IMAGE_NAME}"  \
        "__GITSERVER_PORT_MAPPINGS"  \
        "${__DEBMIN_HOME_DOS}:${__GITSERVER_GUEST_HOME}" \
        "${__DOCKER_COMPOSE_FILE_WLS}"
  Returns:
    ${__DONE}
    ${__INSUFFICIENT_ARGS_STS}
    ${__EMPTY_ARGUMENT_NOT_ALLOWED}
    ${__INVALID_VALUE}
COMMENT--fn__CreateDockerComposeFile-----------------------------------------

function fn__CreateDockerComposeFile() {

  [[ $# -lt 7  ]] && return ${__INSUFFICIENT_ARGS_STS}

  test -z ${1} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}
  test -z ${2} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}
  test -z ${3} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}
  test -z ${4} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}
  test -z ${5} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}
  test -z ${6} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}
  test -z ${7} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}

  # name variables
  #
  local -r pContainerName=${1}
  local -r pHostName=${2}
  local -r pNetworkName=${3}
  local -r pSourceImageNameString=${4}
  local -n pRefContainerMappedPortsArray=${5}  # ref var
  local -r pHostBoundVolumeString=${6}
  local -r pHostWSLPathToComposeFile=${7}

  test ${#pContainerName} -lt 1 && return ${__INVALID_VALUE}
  test ${#pHostName} -lt 1 && return ${__INVALID_VALUE}
  test ${#pNetworkName} -lt 1 && return ${__INVALID_VALUE}
  test ${#pSourceImageNameString} -lt 1 && return ${__INVALID_VALUE}
  test ${#pRefContainerMappedPortsArray} -lt 1 && return ${__INVALID_VALUE}
  test ${#pHostBoundVolumeString} -lt 1 && return ${__INVALID_VALUE}
  test ${#pHostWSLPathToComposeFile} -lt 1 && return ${__INVALID_VALUE}

  local -r lContainerMappedPortsArrayLen=${#pRefContainerMappedPortsArray[@]}
  local -r lNodeModuleAnonVolume=${pHostBoundVolumeString##*:}

  # create Dockerfile
  local TS=$(date '+%Y%m%d_%H%M%S')
  [[ -e ${pHostWSLPathToComposeFile} ]] &&
    cp ${pHostWSLPathToComposeFile} ${pHostWSLPathToComposeFile}_${TS}
    
  cat <<-EOF > ${pHostWSLPathToComposeFile} 
version: "3.7"

services:
    ${pContainerName}:
        container_name: ${pContainerName}
        image: ${pSourceImageNameString}

        restart: always

        entrypoint: /usr/local/bin/docker-entrypoint.sh

        tty: true         # these two keep the container running even if there is no listener in the foreground
        stdin_open: true

        expose:
$(
  for ((i=0; i<${lContainerMappedPortsArrayLen}; i++)) {
    exposePort=${pRefContainerMappedPortsArray[${i}]}
    exposePort=${exposePort##*:}
    exposePort=${exposePort%%/*}
    echo "            - \"${exposePort}\""; 
  }
)

        ports:
$( 
  for ((i=0; i<${lContainerMappedPortsArrayLen}; i++)) { 
    echo "            - \"${pRefContainerMappedPortsArray[${i}]}\""; 
  }
)

        hostname: ${pHostName}
        volumes:
            - "/var/run/docker.sock:/var/run/docker.sock"
            - "${pHostBoundVolumeString}"

networks:
    default:
        driver: bridge
        external:
            name: ${pNetworkName}
EOF

  if [[ -e ${pHostWSLPathToComposeFile}_${TS} ]]; then

    fn__FileSameButForDate \
      ${pHostWSLPathToComposeFile}  \
      ${pHostWSLPathToComposeFile}_${TS} \
        && STS=${__THE_SAME} \
        || STS=${__DIFFERENT}

      if [[ ${STS} -ne ${__DIFFERENT} ]]; then
        echo "______ docker-compose.yml_${pContainerName} changed - container may need updating" >/dev/null
      else
        rm -f ${pHostWSLPathToComposeFile}_${TS}
      fi
  fi
  return ${__DONE}
}


:<<-'COMMENT--fn__SetEnvironmentVariables-----------------------------------------'
  Usage:
    fn__SetEnvironmentVariables
      "${__DEBMIN_HOME}" \
      "${__GITSERVER_USERNAME}" \
      "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}" \
      "__DEBMIN_HOME" \
      "__DEBMIN_HOME_WSD" \
      "__DEBMIN_HOME_DOS" \
      "__DOCKER_COMPOSE_FILE_WLS" \
      "__DOCKER_COMPOSE_FILE_DOS" \
      "__CONTAINER_SOURCE_IMAGE_NAME"
  Returns:
    ${__SUCCESS}
    ${__INSUFFICIENT_ARGS_STS}
    ${__EMPTY_ARGUMENT_NOT_ALLOWED}
    ${__INVALID_VALUE}
COMMENT--fn__SetEnvironmentVariables-----------------------------------------

function fn__SetEnvironmentVariables() {

  ## expect directory structure like
  ## /mnt/x/dir1/dir2/..dirN/projectDir/_commonUtils/02_create_node13131_container
  ## and working directory /mnt/x/dir1/dir2/..dirN/projectDir/_commonUtils

  [[ $# -lt 9  ]] && return ${__INSUFFICIENT_ARGS_STS}

  test -z ${1} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}
  test -z ${2} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}
  test -z ${3} 2>/dev/null && return ${__EMPTY_ARGUMENT_NOT_ALLOWED}

  # name variables
  #
  local -r lrDebminHomeIn=${1}
  local -r lrGitserverUsername=${2}
  local -r lrGitserverImageNameAndVersion=${3}
  local -r lrDebminHomeOut=${4}
  local -r lrDebminHomeOutWSD=${5} 
  local -r lrDebminHomeOutDOS=${6}
  local -r lrDockerComposeFileWSL=${7}
  local -r lrDockerComposeFileDOS=${8}
  local -r lrContainerSourceImage=${9}

  test ${#lrDebminHomeIn} -lt 1 && return ${__INVALID_VALUE}
  test ${#lrGitserverUsername} -lt 1 && return ${__INVALID_VALUE}
  test ${#lrGitserverImageNameAndVersion} -lt 1 && return ${__INVALID_VALUE}
  test ${#lrDebminHomeOut} -lt 1 && return ${__INVALID_VALUE}
  test ${#lrDebminHomeOutWSD} -lt 1 && return ${__INVALID_VALUE}
  test ${#lrDebminHomeOutDOS} -lt 1 && return ${__INVALID_VALUE}
  test ${#lrDockerComposeFileWSL} -lt 1 && return ${__INVALID_VALUE}
  test ${#lrDockerComposeFileDOS} -lt 1 && return ${__INVALID_VALUE}
  test ${#lrContainerSourceImage} -lt 1 && return ${__INVALID_VALUE}

  local -n lrefDebminHomeOut=${4}
  local -n lrefDebminHomeOutWSD=${5} 
  local -n lrefDebminHomeOutDOS=${6}
  local -n lrefDockerComposeFileWSL=${7}
  local -n lrefDockerComposeFileDOS=${8}
  local -n lrefContainerSourceImage=${9}

  # set environment
  #
  # mkdir -pv ${lrDebminHomeIn}

  test -d ${lrDebminHomeIn} || return ${__NO_SUCH_DIRECTORY}

  lrefDebminHomeOut=${lrDebminHomeIn%%/${__SCRIPTS_DIRECTORY_NAME}} # strip _commonUtils
  test -d ${lrefDebminHomeOut} || return ${__NO_SUCH_DIRECTORY}

  cd ${lrefDebminHomeOut}|| return ${__NO_SUCH_DIRECTORY}

  local lContainerName=${lrefDebminHomeOut##*/} # strip directory hierarchy before parent of _commonUtils
  lContainerName=${lContainerName//[ _^%@-]/}  # remove special characters, if any, from project name

  # reduce project name to no more than __MaxNameLen__ characters
  local -ri __MaxNameLen__=15
  local -ri nameLen=${#lContainerName}
  local startPos=$((${nameLen}-${__MaxNameLen__})) 
  startPos=${startPos//-*/0} 
  local -r lContainerName=${lContainerName:${startPos}}

  lrefDebminHomeOutWSD=$(fn__WSLPathToWSDPath ${lrefDebminHomeOut})
  lrefDebminHomeOutDOS=$(fn__WSLPathToRealDosPath ${lrefDebminHomeOut})

  lrefDockerComposeFileWSL="${lrefDebminHomeOut}/docker-compose.yml_${lContainerName}"
  lrefDockerComposeFileDOS="${lrefDebminHomeOutDOS}\\docker-compose.yml_${lContainerName}"

  lrefContainerSourceImage="${lrGitserverImageNameAndVersion}"

  # echo "lrefDebminHomeOut:${lrefDebminHomeOut}"
  # echo "lrefDebminHomeOutWSD:${lrefDebminHomeOutWSD} "
  # echo "lrefDebminHomeOutDOS:${lrefDebminHomeOutDOS}"
  # echo "lrefDockerComposeFileWSL:${lrefDockerComposeFileWSL}"
  # echo "lrefDockerComposeFileDOS:${lrefDockerComposeFileDOS}"
  # echo "lrefContainerSourceImage:${lrefContainerSourceImage}"

  return ${__SUCCESS}
}
