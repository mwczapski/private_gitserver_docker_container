# #############################################
# The MIT License (MIT)
#
# Copyright Â© 2020 Michael Czapski
# #############################################

declare -u _02_create_gitserver_container_utils_tests="SOURCED"

[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__GitserverGeneric} ]] || source ./utils/fn__GitserverGeneric.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh

[[ ${bash_test_utils} ]] || source ./bash_test_utils/bash_test_utils.sh

[[ ${_02_create_gitserver_container_utils} ]] || source ./02_create_gitserver_container_utils.sh

declare -i iSuccessResults=0
declare -i iFailureResults=0

declare functionName
declare functionInputs
declare expectedStringResult
declare expectedStatusResult
declare expectedContentSameResult
declare actualStringResult
declare actualStatusResult
declare actualContentSameResult

declare -r gTS=$(date +%s)

declare -r _TEMP_DIR_PREFIX=/tmp/$( basename ${0} )_
declare -r _TEMP_DIR_=${_TEMP_DIR_PREFIX}${gTS}

declare -i _RUN_TEST_SET_=${__NO}

# defining _FORCE_RUNNING_ALL_TESTS_ will force all test sets in this suite 
# to be executed regardless of the setting for each test set
#
#_FORCE_RUNNING_ALL_TESTS_=""

## ############################################################################
## test files
## ############################################################################

mkdir -p ${_TEMP_DIR_}


cat <<'EOF' > ${_TEMP_DIR_}/docker-compose.yml_gitserver_expected
version: "3.7"

services:
    gitserver:
        container_name: gitserver
        image: gitserver:1.0.0

        restart: always

        entrypoint: /usr/local/bin/docker-entrypoint.sh

        tty: true         # these two keep the container running even if there is no listener in the foreground
        stdin_open: true

        expose:
            - "22"

        ports:
            - "127.0.0.1:40022:22/tcp"

        hostname: gitserver
        volumes:
            - "/var/run/docker.sock:/var/run/docker.sock"
            - "d:/gitserver/gitserver/backups:/home/git/backups"

networks:
    default:
        driver: bridge
        external:
            name: devcicd_net
EOF



## ############################################################################
## test sets
## ############################################################################





functionName="fn__CreateDockerComposeFile"
:<<-'------------Function_Usage_Note-------------------------------'
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
  Expects in environment:
    Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------
_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __INSUFFICIENT_ARGS_STS"
  function fn__FunctionTestTemplate_test_001 {
    local -r lrGitserverContainerName=""  # "${__GITSERVER_CONTAINER_NAME}"
    local -r lrGitserverHostName=""       # "${__GITSERVER_HOST_NAME}"
    local -r lrDevCiCdNet=""              # "${__DEVCICD_NET}"
    local -r lrDebminSourceImageName=""   # "${__DEBMIN_SOURCE_IMAGE_NAME}"
    local lGitserverPortMappingsArry=""   # "__GITSERVER_PORT_MAPPINGS"
    local -r lrDockerBoundVolumeSpec=""   # "${__DEBMIN_HOME_DOS}:${__GITSERVER_GUEST_HOME}"
    local -r lrDockerCmposeFileWSL=""     # "${__DOCKER_COMPOSE_FILE_WLS}"

    expectedStringResult=""
    expectedStatusResult=${__INSUFFICIENT_ARGS_STS}

    ${functionName} && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__FunctionTestTemplate_test_001


  testIntent="${functionName} will return __EMPTY_ARGUMENT_NOT_ALLOWED"
  function fn__FunctionTestTemplate_test_002 {
    local -r lrGitserverContainerName=""  # "${__GITSERVER_CONTAINER_NAME}"
    local -r lrGitserverHostName=""       # "${__GITSERVER_HOST_NAME}"
    local -r lrDevCiCdNet=""              # "${__DEVCICD_NET}"
    local -r lrDebminSourceImageName=""   # "${__DEBMIN_SOURCE_IMAGE_NAME}"
    local lGitserverPortMappingsArry=""   # "__GITSERVER_PORT_MAPPINGS"
    local -r lrDockerBoundVolumeSpec=""   # "${__DEBMIN_HOME_DOS}:${__GITSERVER_GUEST_HOME}"
    local -r lrDockerCmposeFileWSL=""     # "${__DOCKER_COMPOSE_FILE_WLS}"

    expectedStringResult=""
    expectedStatusResult=${__EMPTY_ARGUMENT_NOT_ALLOWED}

    ${functionName} "" "" "" "" "" "" "" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__FunctionTestTemplate_test_002


  testIntent="${functionName} will return __EMPTY_ARGUMENT_NOT_ALLOWED"
  function fn__FunctionTestTemplate_test_003 {
    local -r lrGitserverContainerName=""  # "${__GITSERVER_CONTAINER_NAME}"
    local -r lrGitserverHostName=""       # "${__GITSERVER_HOST_NAME}"
    local -r lrDevCiCdNet=""              # "${__DEVCICD_NET}"
    local -r lrDebminSourceImageName=""   # "${__DEBMIN_SOURCE_IMAGE_NAME}"
    local lGitserverPortMappingsArry=""   # "__GITSERVER_PORT_MAPPINGS"
    local -r lrDockerBoundVolumeSpec=""   # "${__DEBMIN_HOME_DOS}:${__GITSERVER_GUEST_HOME}"
    local -r lrDockerCmposeFileWSL=""     # "${__DOCKER_COMPOSE_FILE_WLS}"

    expectedStringResult=""
    expectedStatusResult=${__EMPTY_ARGUMENT_NOT_ALLOWED}

    ${functionName} \
      "${lrGitserverContainerName}" \
      "${lrGitserverHostName}" \
      "${lrDevCiCdNet}" \
      "${lrDebminSourceImageName}" \
      "lGitserverPortMappingsArry" \
      "${lrDockerBoundVolumeSpec}" \
      "${lrDockerCmposeFileWSL}" \
        && actualStatusResult=$? || actualStatusResult=$?
        
    actualStringResult=""
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__FunctionTestTemplate_test_003


  function fn__FunctionTestTemplate_test_004 {
    local -r lrGitserverContainerName="gitserver"  #  "${__GITSERVER_CONTAINER_NAME}"
    local -r lrGitserverHostName="gitserver"       # "${__GITSERVER_HOST_NAME}"
    local -r lrDevCiCdNet="devcicd_net"             # "${__DEVCICD_NET}"
    local -r lrDebminSourceImageName="gitserver:1.0.0"   # "${__DEBMIN_SOURCE_IMAGE_NAME}"
    local lGitserverPortMappingsArry[0]="127.0.0.1:${__GIT_HOST_PORT}:${_GIT_GUEST_PORT_}/tcp"  # can't be readonly - gives exception # "__GITSERVER_PORT_MAPPINGS"
    local -r lrDockerBoundVolumeSpec="d:/gitserver/gitserver/backups:/home/git/backups"   # "${__DEBMIN_HOME_DOS}:${__GITSERVER_GUEST_HOME}"
    local -r lrDockerCmposeFileWSL="${_TEMP_DIR_}/docker-compose.yml_gitserver"     # "${__DOCKER_COMPOSE_FILE_WLS}"

    testIntent="${functionName} will return __SUCCESS"
    function fn__TestFunctionExecution() {

      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      ${functionName} \
        "${lrGitserverContainerName}" \
        "${lrGitserverHostName}" \
        "${lrDevCiCdNet}" \
        "${lrDebminSourceImageName}" \
        "lGitserverPortMappingsArry" \
        "${lrDockerBoundVolumeSpec}" \
        "${lrDockerCmposeFileWSL}" \
          && actualStatusResult=$? || actualStatusResult=$?
          
      actualStringResult=""
      # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__TestFunctionExecution

    testIntent="${functionName} will return __THE_SAME completion code having compared expected and generated files"
    function fn__TestFunctionOutput() {
      
      expectedStringResult=""
      expectedStatusResult=${__THE_SAME}

      local -r lExpectedFileName=${_TEMP_DIR_}/docker-compose.yml_gitserver_expected
      local -r lActualFileName=${_TEMP_DIR_}/docker-compose.yml_gitserver

      fn__FileSameButForDate ${lExpectedFileName} ${lActualFileName} && actualStatusResult=$? || actualStatusResult=$?
      actualStringResult=""

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__TestFunctionOutput

  }
  fn__FunctionTestTemplate_test_004


  function fn__FunctionTestTemplate_test_005 {
    local -r lrGitserverContainerName="gitserverX"  #  "${__GITSERVER_CONTAINER_NAME}"
    local -r lrGitserverHostName="gitserverY"       # "${__GITSERVER_HOST_NAME}"
    local -r lrDevCiCdNet="devcicd_netZ"             # "${__DEVCICD_NET}"
    local -r lrDebminSourceImageName="gitserver:1.0.1"   # "${__DEBMIN_SOURCE_IMAGE_NAME}"
    local lGitserverPortMappingsArry[0]="127.0.0.2:${__GIT_HOST_PORT}:${_GIT_GUEST_PORT_}/tcp"  # can't be readonly - gives exception # "__GITSERVER_PORT_MAPPINGS"
    local -r lrDockerBoundVolumeSpec="d:/gitserver/gitserver/backups:/home/git/backups"   # "${__DEBMIN_HOME_DOS}:${__GITSERVER_GUEST_HOME}"
    local -r lrDockerCmposeFileWSL="${_TEMP_DIR_}/docker-compose.yml_gitserver"     # "${__DOCKER_COMPOSE_FILE_WLS}"

    testIntent="${functionName} will return __SUCCESS"
    function fn__TestFunctionExecution() {

      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      ${functionName} \
        "${lrGitserverContainerName}" \
        "${lrGitserverHostName}" \
        "${lrDevCiCdNet}" \
        "${lrDebminSourceImageName}" \
        "lGitserverPortMappingsArry" \
        "${lrDockerBoundVolumeSpec}" \
        "${lrDockerCmposeFileWSL}" \
          && actualStatusResult=$? || actualStatusResult=$?
          
      actualStringResult=""
      # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__TestFunctionExecution

    testIntent="${functionName} will return __DIFFERENT completion code having compared expected and generated files"
    function fn__TestFunctionOutput() {
      
      expectedStringResult=""
      expectedStatusResult=${__DIFFERENT}

      local -r lExpectedFileName=${_TEMP_DIR_}/docker-compose.yml_gitserver_expected
      local -r lActualFileName=${_TEMP_DIR_}/docker-compose.yml_gitserver

      fn__FileSameButForDate ${lExpectedFileName} ${lActualFileName} && actualStatusResult=$? || actualStatusResult=$?
      actualStringResult=""

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__TestFunctionOutput

  }
  fn__FunctionTestTemplate_test_005


else 
  echo "     . Not running test for ${functionName}" >/dev/null
fi



functionName="fn__SetEnvironmentVariables"
:<<-'------------Function_Usage_Note-------------------------------'
------------Function_Usage_Note-------------------------------
_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __INSUFFICIENT_ARGS_STS"
  function fn__SetEnvironmentVariablese_test_001 {

    expectedStringResult=""
    expectedStatusResult=${__INSUFFICIENT_ARGS_STS}

    ${functionName} && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__SetEnvironmentVariablese_test_001


  testIntent="${functionName} will return __EMPTY_ARGUMENT_NOT_ALLOWED"
  function fn__SetEnvironmentVariables_test_002 {

    expectedStringResult=""
    expectedStatusResult=${__EMPTY_ARGUMENT_NOT_ALLOWED}

    ${functionName} "" "" "" "" "" "" "" "" "" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 
    actualStringResult=""

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__SetEnvironmentVariables_test_002


  testIntent="${functionName} will return __EMPTY_ARGUMENT_NOT_ALLOWED"
  function fn__SetEnvironmentVariables_test_003 {
    local -r lrDebminHome=""  # "${__DEBMIN_HOME}"
    local -r lrGitserverUsername="" #  "${__GITSERVER_USERNAME}"
    local -r lrGitserverImageNameAndVersion=""  # "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"
    local lDebminHomeOut    # "__DEBMIN_HOME"
    local lDebimHomeWSDOut  # "__DEBMIN_HOME_WSD"
    local lDebminHomeDOSOut #"__DEBMIN_HOME_DOS"
    local lDockerComposeFileWSLOut    #  "__DOCKER_COMPOSE_FILE_WLS"
    local lDockerComposeFileDOSOut    #"__DOCKER_COMPOSE_FILE_DOS"
    local lContaierSourceImageNameAndVersion  #  "__CONTAINER_SOURCE_IMAGE_NAME"

    expectedStringResult=""
    expectedStatusResult=${__EMPTY_ARGUMENT_NOT_ALLOWED}

    ${functionName} "${lrDebminHome}" "${lrDebminHome}" "" "" "" "" "" "" "" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__SetEnvironmentVariables_test_003


  testIntent="${functionName} will return __INVALID_VALUE"
  function fn__SetEnvironmentVariables_test_004 {
    local -r lrDebminHome="/mnt/d/gitserver/gitserver/_commonUtils"  # "${__DEBMIN_HOME}"
    local -r lrGitserverUsername="${__GITSERVER_USERNAME}" #  "${__GITSERVER_USERNAME}"
    local -r lrGitserverImageNameAndVersion="${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"  # "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"
    local lDebminHomeOut    # "__DEBMIN_HOME"
    local lDebimHomeWSDOut  # "__DEBMIN_HOME_WSD"
    local lDebminHomeDOSOut #"__DEBMIN_HOME_DOS"
    local lDockerComposeFileWSLOut    #  "__DOCKER_COMPOSE_FILE_WLS"
    local lDockerComposeFileDOSOut    #"__DOCKER_COMPOSE_FILE_DOS"
    local lContaierSourceImageNameAndVersion  #  "__CONTAINER_SOURCE_IMAGE_NAME"

    expectedStringResult=""
    expectedStatusResult=${__INVALID_VALUE}

    ${functionName} "${lrDebminHome}" "${lrGitserverUsername}" "${lrGitserverImageNameAndVersion}" "lDebminHomeOut" "" "" "" "" "" "" "" "" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__SetEnvironmentVariables_test_004


  testIntent="${functionName} will return __SUCCESS"
  function fn__SetEnvironmentVariables_test_005 {
    local -r lrDebminHome="/mnt/d/gitserver/gitserver/_commonUtils"  # "${__DEBMIN_HOME}"
    local -r lrGitserverUsername="${__GITSERVER_USERNAME}" #  "${__GITSERVER_USERNAME}"
    local -r lrGitserverImageNameAndVersion="${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"  # "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"
    # local lDebminHomeOut    # "__DEBMIN_HOME" - note that though this var is not declared it will be created 
    local lDebimHomeWSDOut  # "__DEBMIN_HOME_WSD"
    local lDebminHomeDOSOut #"__DEBMIN_HOME_DOS"
    local lDockerComposeFileWSLOut    #  "__DOCKER_COMPOSE_FILE_WLS"
    local lDockerComposeFileDOSOut    #"__DOCKER_COMPOSE_FILE_DOS"
    local lContaierSourceImageNameAndVersion  #  "__CONTAINER_SOURCE_IMAGE_NAME"
    
    expectedStringResult=""
    expectedStatusResult=${__SUCCESS}

    ${functionName} \
      "${lrDebminHome}" \
      "${lrGitserverUsername}" \
      "${lrGitserverImageNameAndVersion}" \
      "lDebminHomeOut" \
      "lDebimHomeWSDOut" \
      "lDebminHomeDOSOut" \
      "lDockerComposeFileWSLOut" \
      "lDockerComposeFileDOSOut" \
      "lContaierSourceImageNameAndVersion" && actualStatusResult=$? || actualStatusResult=$?

    actualStringResult=""
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__SetEnvironmentVariables_test_005


  testIntent="${functionName} will return __SUCCESS"
  function fn__SetEnvironmentVariables_test_006 {
    local -r lrDebminHome="/mnt/d/gitserver/gitserver/_commonUtils"  # "${__DEBMIN_HOME}"
    local -r lrGitserverUsername="${__GITSERVER_USERNAME}" #  "${__GITSERVER_USERNAME}"
    local -r lrGitserverImageNameAndVersion="${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"  # "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"
    local lDebminHomeOut    # "__DEBMIN_HOME"
    local lDebimHomeWSDOut  # "__DEBMIN_HOME_WSD"
    local lDebminHomeDOSOut #"__DEBMIN_HOME_DOS"
    local lDockerComposeFileWSLOut    #  "__DOCKER_COMPOSE_FILE_WLS"
    local lDockerComposeFileDOSOut    #"__DOCKER_COMPOSE_FILE_DOS"
    local lContaierSourceImageNameAndVersion  #  "__CONTAINER_SOURCE_IMAGE_NAME"
    
    expectedStringResult=""
    expectedStatusResult=${__SUCCESS}

    ${functionName} \
      "${lrDebminHome}" \
      "${lrGitserverUsername}" \
      "${lrGitserverImageNameAndVersion}" \
      "lDebminHomeOut" \
      "lDebimHomeWSDOut" \
      "lDebminHomeDOSOut" \
      "lDockerComposeFileWSLOut" \
      "lDockerComposeFileDOSOut" \
      "lContaierSourceImageNameAndVersion" && actualStatusResult=$? || actualStatusResult=$?

    actualStringResult=""
    # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__SetEnvironmentVariables_test_006


  function fn__SetEnvironmentVariables_test_007 {
    local -r lrDebminHome="/mnt/d/gitserver/gitserver/_commonUtils"  # "${__DEBMIN_HOME}"
    local -r lrGitserverUsername="${__GITSERVER_USERNAME}" #  "${__GITSERVER_USERNAME}"
    local -r lrGitserverImageNameAndVersion="${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"  # "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"
    local lDebminHomeOut    # "__DEBMIN_HOME"
    local lDebimHomeWSDOut  # "__DEBMIN_HOME_WSD"
    local lDebminHomeDOSOut #"__DEBMIN_HOME_DOS"
    local lDockerComposeFileWSLOut    #  "__DOCKER_COMPOSE_FILE_WLS"
    local lDockerComposeFileDOSOut    #"__DOCKER_COMPOSE_FILE_DOS"
    local lContaierSourceImageNameAndVersion  #  "__CONTAINER_SOURCE_IMAGE_NAME"
    
    testIntent="${functionName} will return __SUCCESS and set the values of the reference variables"
    fn__testInputAndExecution() {
      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      ${functionName} \
        "${lrDebminHome}" \
        "${lrGitserverUsername}" \
        "${lrGitserverImageNameAndVersion}" \
        "lDebminHomeOut" \
        "lDebimHomeWSDOut" \
        "lDebminHomeDOSOut" \
        "lDockerComposeFileWSLOut" \
        "lDockerComposeFileDOSOut" \
        "lContaierSourceImageNameAndVersion" && actualStatusResult=$? || actualStatusResult=$?

      actualStringResult=""

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__testInputAndExecution

    testIntent="${functionName} will return __SUCCESS and match expected values of all reference variables"
    fn__testOutput() {
      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      local lMismatches=0

      [[ "${lDebminHomeOut}" != "/mnt/d/gitserver/gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebimHomeWSDOut}" != "d:/gitserver/gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebminHomeDOSOut}" != "d:\gitserver\gitserver" ]] && (( lMismatches++ ))
      [[ "${lDockerComposeFileWSLOut}" != "/mnt/d/gitserver/gitserver/docker-compose.yml_gitserver" ]] && (( lMismatches++ ))
      [[ "${lDockerComposeFileDOSOut}" != "d:\gitserver\gitserver\docker-compose.yml_gitserver" ]] && (( lMismatches++ ))
      [[ "${lContaierSourceImageNameAndVersion}" != "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}" ]] && (( lMismatches++ ))

      actualStringResult=""
      actualStatusResult=${lMismatches}

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__testOutput
    
  }
  fn__SetEnvironmentVariables_test_007


  testIntent="${functionName} will return __NO_SUCH_DIRECTORY"
  function fn__SetEnvironmentVariables_test_008 {
    local -r lrDebminHome="/mnt/d/gitserver/gitserver/noSuchDir"  # "${__DEBMIN_HOME}"
    local -r lrGitserverUsername="${__GITSERVER_USERNAME}" #  "${__GITSERVER_USERNAME}"
    local -r lrGitserverImageNameAndVersion="${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"  # "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"
    local lDebminHomeOut    # "__DEBMIN_HOME"
    local lDebimHomeWSDOut  # "__DEBMIN_HOME_WSD"
    local lDebminHomeDOSOut #"__DEBMIN_HOME_DOS"
    local lDockerComposeFileWSLOut    #  "__DOCKER_COMPOSE_FILE_WLS"
    local lDockerComposeFileDOSOut    #"__DOCKER_COMPOSE_FILE_DOS"
    local lContaierSourceImageNameAndVersion  #  "__CONTAINER_SOURCE_IMAGE_NAME"
    
    fn__testInputAndExecution() {
      expectedStringResult=""
      expectedStatusResult=${__NO_SUCH_DIRECTORY}

      ${functionName} \
        "${lrDebminHome}" \
        "${lrGitserverUsername}" \
        "${lrGitserverImageNameAndVersion}" \
        "lDebminHomeOut" \
        "lDebimHomeWSDOut" \
        "lDebminHomeDOSOut" \
        "lDockerComposeFileWSLOut" \
        "lDockerComposeFileDOSOut" \
        "lContaierSourceImageNameAndVersion" && actualStatusResult=$? || actualStatusResult=$?

      # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 
      actualStringResult=""

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__testInputAndExecution
  }
  fn__SetEnvironmentVariables_test_008


  function fn__SetEnvironmentVariables_test_009 {
    local -r lrDebminHome="/mnt/d/gitserver/gitserver/backups"  # "${__DEBMIN_HOME}"
    local -r lrGitserverUsername="${__GITSERVER_USERNAME}" #  "${__GITSERVER_USERNAME}"
    local -r lrGitserverImageNameAndVersion="${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"  # "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}"
    local lDebminHomeOut    # "__DEBMIN_HOME"
    local lDebimHomeWSDOut  # "__DEBMIN_HOME_WSD"
    local lDebminHomeDOSOut #"__DEBMIN_HOME_DOS"
    local lDockerComposeFileWSLOut    #  "__DOCKER_COMPOSE_FILE_WLS"
    local lDockerComposeFileDOSOut    #"__DOCKER_COMPOSE_FILE_DOS"
    local lContaierSourceImageNameAndVersion  #  "__CONTAINER_SOURCE_IMAGE_NAME"
    
    testIntent="${functionName} will return __SUCCESS and set the values of the reference variables"
    fn__testInputAndExecution() {
      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      ${functionName} \
        "${lrDebminHome}" \
        "${lrGitserverUsername}" \
        "${lrGitserverImageNameAndVersion}" \
        "lDebminHomeOut" \
        "lDebimHomeWSDOut" \
        "lDebminHomeDOSOut" \
        "lDockerComposeFileWSLOut" \
        "lDockerComposeFileDOSOut" \
        "lContaierSourceImageNameAndVersion" && actualStatusResult=$? || actualStatusResult=$?

      actualStringResult=""

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__testInputAndExecution

    testIntent="${functionName} will return the non-zero number of variables which did not match expected values"
    fn__testOutput() {
      expectedStringResult=""
      expectedStatusResult=5

      local lMismatches=0

      [[ "${lDebminHomeOut}" != "/mnt/d/gitserver/gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebimHomeWSDOut}" != "d:/gitserver/gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebminHomeDOSOut}" != "d:\gitserver\gitserver" ]] && (( lMismatches++ ))
      [[ "${lDockerComposeFileWSLOut}" != "/mnt/d/gitserver/gitserver/docker-compose.yml_gitserver" ]] && (( lMismatches++ ))
      [[ "${lDockerComposeFileDOSOut}" != "d:\gitserver\gitserver\docker-compose.yml_gitserver" ]] && (( lMismatches++ ))
      [[ "${lContaierSourceImageNameAndVersion}" != "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}" ]] && (( lMismatches++ ))

      actualStringResult=""
      actualStatusResult=${lMismatches}

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    fn__testOutput
  }
  fn__SetEnvironmentVariables_test_009


else 
  echo "     . Not running test for ${functionName}" >/dev/null
fi

















:<<-'TEMPLATES----------------------------------------------------------'

  functionName="fn__FunctionTestTemplate"
  :<<-'------------Function_Usage_Note-------------------------------'
    Usage: 
      fn__FunctionTestTemplate \
        "${__SCRIPTS_DIRECTORY_NAME}" \   # by value
        "__DEBMIN_HOME"  \                # by reference
    Returns:
      ${__SUCCESS}
      ${__INSUFFICIENT_ARGS_STS} or explicit error code
    Expects in environment:
      Constants from __env_GlobalConstants
  ------------Function_Usage_Note-------------------------------
  _RUN_TEST_SET_=${__NO}
  if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
  then

    testIntent="${functionName} will return __INSUFFICIENT_ARGS_STS"
    function fn__FunctionTestTemplate_test_001 {

      expectedStringResult=""
      expectedStatusResult=${__INSUFFICIENT_ARGS_STS}

      ${functionName} && actualStatusResult=$? || actualStatusResult=$?
      actualStringResult=""
      # [[ ${actualStringResult} ]] && echo "____ ${LINENO}: ${functionName}: ${actualStringResult}" 

      assessReturnStatusAndStdOut \
        "${functionName}" \
        ${LINENO} \
        "${testIntent}" \
        "${expectedStringResult}" \
        ${expectedStatusResult} \
        "${actualStringResult}" \
        ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
    }
    # fn__FunctionTestTemplate_test_001


  else 
    echo "     . Not running test for ${functionName}" >/dev/null
  fi
TEMPLATES----------------------------------------------------------


# clean up
# echo ${_TEMP_DIR_}
rm -Rf ${_TEMP_DIR_}
rm -rf ${_TEMP_DIR_PREFIX}[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]

echo "____ Executed $((iSuccessResults+iFailureResults)) tests"
echo "____ ${iSuccessResults} tests were successful"
echo "____ ${iFailureResults} tests failed"

exit ${iFailureResults}
