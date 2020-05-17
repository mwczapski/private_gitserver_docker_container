# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u _01_create_gitserver_image_utils_tests="SOURCED"

[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__GitserverGeneric} ]] || source ./utils/fn__GitserverGeneric.sh

[[ ${bash_test_utils} ]] || source ./bash_test_utils/bash_test_utils.sh

[[ ${_01_create_gitserver_image_utils} ]] || source ./01_create_gitserver_image_utils.sh


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

declare -r _TEMP_DIR_PREFIX=/tmp/01_create_gitserver_image_tests_
declare -r _TEMP_DIR_=${_TEMP_DIR_PREFIX}${gTS}

declare -i _RUN_TEST_SET_=${__NO}

# defining _FORCE_RUNNING_ALL_TESTS_ will force all test sets in this suite 
# to be executed regardless of the setting for each test set
#
#_FORCE_RUNNING_ALL_TESTS_=""

## ############################################################################
## test sets
## ############################################################################


functionName="fn__SetEnvironmentVariables"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__SetEnvironmentVariables \
      "${__SCRIPTS_DIRECTORY_NAME}" \
      "${__GITSERVER_IMAGE_NAME}"  \
      "${__GITSERVER_SHELL_GLOBAL_PROFILE}"  \
      "__DEBMIN_HOME"  \
      "__DEBMIN_HOME_DOS"  \
      "__DEBMIN_HOME_WSD" \
      "__DEBMIN_SOURCE_IMAGE_NAME"  \
      "__TZ_PATH"  \
      "__TZ_NAME"  \
      "__ENV"  \
      "__DOCKERFILE_PATH"  \
      "__REMOVE_CONTAINER_ON_STOP"  \
      "__NEEDS_REBUILDING"  \
  Returns:
    ${__SUCCESS}
    ${__FAILED} and error string on stdout
  Expects in environment:
    Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------

_RUN_TEST_SET_=${__YES}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __FAILED and '______ Insufficient number of arguments'"
  function fn__SetEnvironmentVariables_test_001 {

    expectedStringResult="______ Insufficient number of arguments"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} "" "" "" ) && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__SetEnvironmentVariables_test_001


  testIntent="${functionName} will return __FAILED and '1st Argument value, '', is invalid'"
  function fn__SetEnvironmentVariables_test_002 {
    local -r lrScriptDirectoryName=${__SCRIPTS_DIRECTORY_NAME}
    local -r lrGotserverImageName="${__GITSERVER_IMAGE_NAME}"
    local -r lrGitserverShellGlobalProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
    

    expectedStringResult="1st Argument value, '', is invalid"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} "" "" "" "" "" "" "" "" "" "" "" "" "") && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 

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


  testIntent="${functionName} will return __FAILED and 2nd Argument value, '', is invalid"
  function fn__SetEnvironmentVariables_test_003 {
    local -r lrScriptDirectoryName="${__SCRIPTS_DIRECTORY_NAME}"
    local -r lrGotserverImageName="${__GITSERVER_IMAGE_NAME}"
    local -r lrGitserverShellGlobalProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
    

    expectedStringResult="2nd Argument value, '', is invalid"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} "${lrScriptDirectoryName}" "" "" "" "" "" "" "" "" "" "" "" "") && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 

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


  testIntent="${functionName} will return __FAILED and 3rd Argument value, '', is invalid"
  function fn__SetEnvironmentVariables_test_004 {
    local -r lrScriptDirectoryName="${__SCRIPTS_DIRECTORY_NAME}"
    local -r lrGitserverImageName="${__GITSERVER_IMAGE_NAME}"
    local -r lrGitserverShellGlobalProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
    

    expectedStringResult="3rd Argument value, '', is invalid"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} "${lrScriptDirectoryName}" "${lrGitserverImageName}" "" "" "" "" "" "" "" "" "" "" "") && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 

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


  testIntent="${functionName} will return __FAILED and '4th Argument, 'lDebminHome', is not declared'"
  function fn__SetEnvironmentVariables_test_005 {
    local -r lrScriptDirectoryName="${__SCRIPTS_DIRECTORY_NAME}"
    local -r lrGitserverImageName="${__GITSERVER_IMAGE_NAME}"
    local -r lrGitserverShellGlobalProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
    # local lDebminHome="/mnt/d/gitserver/gitserver/_commonUtils"
    # local lDebminHome=""
    local lDebminHomeDOS=""
    local lDebminHomeWSD=""
    local lDebminSourceImageName=""
    local lTZPath=""
    local lTZName=""
    local lGlobalShellProfile=""
    local lDockerfilePath=""
    local lRemoveContainerOnStop=""
    local lNeedsRebuilding=""
    

    expectedStringResult="4th Argument, 'lDebminHome', must have a valid value"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} \
                              "${lrScriptDirectoryName}" \
                              "${lrGitserverImageName}" \
                              "${lrGitserverShellGlobalProfile}" \
                              "lDebminHome" \
                              "lDebminHomeDOS" \
                              "lDebminHomeWSD" \
                              "lDebminSourceImageName" \
                              "lTZPath" \
                              "lTZName" \
                              "lGlobalShellProfile" \
                              "lDockerfilePath" \
                              "lRemoveContainerOnStop" \
                              "lNeedsRebuilding" ) && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 

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


  testIntent="${functionName} will return __FAILED and '4th Argument, 'lDebminHome', must have a valid value'"
  function fn__SetEnvironmentVariables_test_006 {
    local -r lrScriptDirectoryName="${__SCRIPTS_DIRECTORY_NAME}"
    local -r lrGitserverImageName="${__GITSERVER_IMAGE_NAME}"
    local -r lrGitserverShellGlobalProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
    # local lDebminHome="/mnt/d/gitserver/gitserver/_commonUtils"
    local lDebminHome=""
    local lDebminHomeDOS=""
    local lDebminHomeWSD=""
    local lDebminSourceImageName=""
    local lTZPath=""
    local lTZName=""
    local lGlobalShellProfile=""
    local lDockerfilePath=""
    local lRemoveContainerOnStop=""
    local lNeedsRebuilding=""
    

    expectedStringResult="4th Argument, 'lDebminHome', must have a valid value"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} \
                              "${lrScriptDirectoryName}" \
                              "${lrGitserverImageName}" \
                              "${lrGitserverShellGlobalProfile}" \
                              "lDebminHome" \
                              "lDebminHomeDOS" \
                              "lDebminHomeWSD" \
                              "lDebminSourceImageName" \
                              "lTZPath" \
                              "lTZName" \
                              "lGlobalShellProfile" \
                              "lDockerfilePath" \
                              "lRemoveContainerOnStop" \
                              "lNeedsRebuilding" ) && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 

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
    local -r lrScriptDirectoryName="${__SCRIPTS_DIRECTORY_NAME}"
    local -r lrGitserverImageName="${__GITSERVER_IMAGE_NAME}"
    local -r lrGitserverShellGlobalProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
    local lDebminHome="/mnt/d/gitserver/gitserver/_commonUtils"
    local lDebminHomeDOS=""
    local lDebminHomeWSD=""
    local lDebminSourceImageName=""
    local lTZPath=""
    local lTZName=""
    local lGlobalShellProfile=""
    local lDockerfilePath=""
    local lRemoveContainerOnStop=""
    local lNeedsRebuilding=""
    
    testIntent="${functionName} will return __SUCCESS and set the values of the reference variables"
    fn__testInputAndExecution() {
      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      ${functionName} \
        "${lrScriptDirectoryName}" \
        "${lrGitserverImageName}" \
        "${lrGitserverShellGlobalProfile}" \
        "lDebminHome" \
        "lDebminHomeDOS" \
        "lDebminHomeWSD" \
        "lDebminSourceImageName" \
        "lTZPath" \
        "lTZName" \
        "lGlobalShellProfile" \
        "lDockerfilePath" \
        "lRemoveContainerOnStop" \
        "lNeedsRebuilding" && actualStatusResult=$? || actualStatusResult=$?
      # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 

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

      [[ "${lDebminHome}" != "/mnt/d/gitserver/gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebminHomeDOS}" != "d:\gitserver\gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebminHomeWSD}" != "d:/gitserver/gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebminSourceImageName}" != "bitnami/minideb:jessie" ]] && (( lMismatches++ ))
      [[ "${lTZPath}" != "Australia/Sydney" ]] && (( lMismatches++ ))
      [[ "${lTZName}" != "Australia/Sydney" ]] && (( lMismatches++ ))
      [[ "${lGlobalShellProfile}" != "/etc/profile" ]] && (( lMismatches++ ))
      [[ "${lDockerfilePath}" != "/mnt/d/gitserver/gitserver/Dockerfile.gitserver" ]] && (( lMismatches++ ))
      [[ "${lRemoveContainerOnStop}" != "0" ]] && (( lMismatches++ ))
      [[ "${lNeedsRebuilding}" != "1" ]] && (( lMismatches++ ))

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


  testIntent="${functionName} will return __FAILED and error changing directory to the non-existent directory"
  function fn__SetEnvironmentVariables_test_008 {
    local -r lrScriptDirectoryName="${__SCRIPTS_DIRECTORY_NAME}"
    local -r lrGitserverImageName="${__GITSERVER_IMAGE_NAME}"
    local -r lrGitserverShellGlobalProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
    local lDebminHome="/mnt/d/gitserver/gitserver/_commonUtils/areNotRight"
    local lDebminHomeDOS=""
    local lDebminHomeWSD=""
    local lDebminSourceImageName=""
    local lTZPath=""
    local lTZName=""
    local lGlobalShellProfile=""
    local lDockerfilePath=""
    local lRemoveContainerOnStop=""
    local lNeedsRebuilding=""
    
    fn__testInputAndExecution() {
      expectedStringResult="cd: /mnt/d/gitserver/gitserver/_commonUtils/areNotRight: No such file or directory"
      expectedStatusResult=${__FAILED}

      actualStringResult=$( ${functionName} \
        "${lrScriptDirectoryName}" \
        "${lrGitserverImageName}" \
        "${lrGitserverShellGlobalProfile}" \
        "lDebminHome" \
        "lDebminHomeDOS" \
        "lDebminHomeWSD" \
        "lDebminSourceImageName" \
        "lTZPath" \
        "lTZName" \
        "lGlobalShellProfile" \
        "lDockerfilePath" \
        "lRemoveContainerOnStop" \
        "lNeedsRebuilding" ) && actualStatusResult=$? || actualStatusResult=$?
      # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 

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
    local -r lrScriptDirectoryName="${__SCRIPTS_DIRECTORY_NAME}"
    local -r lrGitserverImageName="${__GITSERVER_IMAGE_NAME}"
    local -r lrGitserverShellGlobalProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
    local lDebminHome="/mnt/d/gitserver/gitserver/backups"
    local lDebminHomeDOS=""
    local lDebminHomeWSD=""
    local lDebminSourceImageName=""
    local lTZPath=""
    local lTZName=""
    local lGlobalShellProfile=""
    local lDockerfilePath=""
    local lRemoveContainerOnStop=""
    local lNeedsRebuilding=""
    
    testIntent="${functionName} will return __SUCCESS and set values of all reference variables"
    fn__testInputAndExecution() {
      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      ${functionName} \
        "${lrScriptDirectoryName}" \
        "${lrGitserverImageName}" \
        "${lrGitserverShellGlobalProfile}" \
        "lDebminHome" \
        "lDebminHomeDOS" \
        "lDebminHomeWSD" \
        "lDebminSourceImageName" \
        "lTZPath" \
        "lTZName" \
        "lGlobalShellProfile" \
        "lDockerfilePath" \
        "lRemoveContainerOnStop" \
        "lNeedsRebuilding" && actualStatusResult=$? || actualStatusResult=$?
      # [[ ${actualStringResult} ]] && echo "______ ${LINENO}: ${functionName}: ${actualStringResult}" 
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

    testIntent="${functionName} will return __FAILED and fail to match 4 variables"
    fn__testOutput() {
      expectedStringResult=""
      expectedStatusResult=4

      local lMismatches=0
      [[ "${lDebminHome}" != "/mnt/d/gitserver/gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebminHomeDOS}" != "d:\gitserver\gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebminHomeWSD}" != "d:/gitserver/gitserver" ]] && (( lMismatches++ ))
      [[ "${lDebminSourceImageName}" != "bitnami/minideb:jessie" ]] && (( lMismatches++ ))
      [[ "${lTZPath}" != "Australia/Sydney" ]] && (( lMismatches++ ))
      [[ "${lTZName}" != "Australia/Sydney" ]] && (( lMismatches++ ))
      [[ "${lGlobalShellProfile}" != "/etc/profile" ]] && (( lMismatches++ ))
      [[ "${lDockerfilePath}" != "/mnt/d/gitserver/gitserver/Dockerfile.gitserver" ]] && (( lMismatches++ ))
      [[ "${lRemoveContainerOnStop}" != "0" ]] && (( lMismatches++ ))
      [[ "${lNeedsRebuilding}" != "1" ]] && (( lMismatches++ ))

      actualStringResult="Failed to match ${lMismatches} variable assignments"
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
  echo "     . Not running test for ${functionName}"
fi
