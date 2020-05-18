#!/bin/bash
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -ur bash_test_utils="SOURCED"

[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh


# defining _FORCE_RUNNING_ALL_TESTS_ will force all test sets in this suite 
# to be executed regardless of the setting for each test set
#
#_FORCE_RUNNING_ALL_TESTS_=""

## ############################################################################
## testing utility functions
## ############################################################################

:<<-'------------Function_Usage_Note-------------------------------'
  Usage:
    assessReturnStatusAndStdOut \
      ${functionName} \
      ${lineNum} \
      ${testIntent} \
      ${expectedStringResult} \
      ${expectedStatusResult} \
      ${actualStringResult} \
      ${actualStatusResult} \
        && return ${__SUCCESS} \
        || return ${__FAILED}
  Returns:
    ${__DONE}
    ${__FAILED}
  Expects in environment:
    Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------
function assessReturnStatusAndStdOut() {
  local -r lUsage='
  Usage: 
    assessReturnStatusAndStdOut
      ${functionName} \
      ${lineNum} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} \
  Returns:
    ${__DONE}
    ${__FAILED}
  Expects in environment:
    Constants from __env_GlobalConstants
  '
  [[ $# -lt  7 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }

  local -r xFunctionName=${1?"${lUsage}"}
  local -r xLineNum=${2?"${lUsage}"}
  local -r xTestIntent=${3?"${lUsage}"}
  local -r xExpectedStringResult=${4?"${lUsage}"}
  local -r xExpectedStatusResult=${5?"${lUsage}"}
  local -r xActualStringResult=${6?"${lUsage}"}
  local -r xActualStatusResult=${7?"${lUsage}"}

  local lActualStringResultCutToExpectedLen=${xActualStringResult:0:${#xExpectedStringResult}}

  if [[ "${xExpectedStringResult}" == "${lActualStringResultCutToExpectedLen}" \
      && ${xExpectedStatusResult} -eq ${xActualStatusResult} ]]
  then
      echo "PASS ${xLineNum}: ${xTestIntent}" 
      return ${__SUCCESS}
  else
      echo "FAIL ${xLineNum}: ${xFunctionName}: Exp:${xExpectedStringResult} != Act:${lActualStringResultCutToExpectedLen} (Exp: ${xExpectedStatusResult} -ne Act:${xActualStatusResult})" 
      return ${__FAILED}
  fi
}



## ############################################################################
## test sets
## ############################################################################


functionName="assessReturnStatusAndStdOut"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage:
    assessReturnStatusAndStdOut \
      ${functionName} \
      ${testIntent} \
      ${expectedStringResult} \
      ${expectedStatusResult} \
      ${actualStringResult} \
      ${actualStatusResult} \
        && return ${__SUCCESS} \
        || return ${__FAILED}
  Returns:
    ${__DONE}
    ${__FAILED}
  Expects in environment:
    Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------
_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} function will return __FAILURE, insufficient number of arguments and Usage message"
  function assessReturnStatusAndStdOut_test_001 {
    local -r pFunctionName="${functionName}"
    local -r pTestIntent="${testIntent}"
    local -r pExpectedStringResult="${__INSUFFICIENT_ARGS}"
    local -r pExpectedStatusResult=${__FAILED}
    local pActualStringResult=""
    local pActualStatusResult=0

    # excute function
    pActualStringResult=$( ${pFunctionName} ) && pActualStatusResult=$? || pActualStatusResult=$?

    assessReturnStatusAndStdOut \
      "${pFunctionName}" \
      ${LINENO} \
      "${pTestIntent}" \
      "${pExpectedStringResult}" \
      ${pExpectedStatusResult} \
      "${pActualStringResult}" \
      ${pActualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  assessReturnStatusAndStdOut_test_001

# else 
#   echo "     . Not running test for ${functionName}"
fi
