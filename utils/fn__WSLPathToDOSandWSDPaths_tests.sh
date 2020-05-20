# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__WSLPathToDOSandWSDPaths_tests="SOURCED"

[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__WSLPathToDOSandWSDPaths} ]] || source ./utils/fn__WSLPathToDOSandWSDPaths.sh

[[ ${bash_test_utils} ]] || source ./bash_test_utils/bash_test_utils.sh



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

declare -r _TEMP_DIR_PREFIX=/tmp/tests_
declare -r _TEMP_DIR_=${_TEMP_DIR_PREFIX}${gTS}

declare -i _RUN_TEST_SET_=${__NO}

# defining _FORCE_RUNNING_ALL_TESTS_ will force all test sets in this suite 
# to be executed regardless of the setting for each test set
#
#_FORCE_RUNNING_ALL_TESTS_=""

## ############################################################################
## test sets
## ############################################################################


functionName="fn__WSLPathToWSDPath"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__WSLPathToWSDPath \
      ${WSLPath}
  Returns:
    ${__DONE}
    ${__FAILED}
  Expects in environment:
    Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------

_RUN_TEST_SET_=${__YES}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __FAILURE, insufficient number of arguments and Usage message"
  function fn__WSLPathToWSDPath_test_001() {
    expectedStringResult=""
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$? 
    # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__WSLPathToWSDPath_test_001


  testIntent="${functionName} will return __SUCCESS and the the pseudo-DOS path"
  function fn__WSLPathToWSDPath_test_002() {
    pWSLPath="/mnt/d/gitserver/gitserver/_commonUtils/utils"
    expectedStringResult="d:/gitserver/gitserver/_commonUtils/utils"
    expectedStatusResult=${__SUCCESS}

    actualStringResult=$( ${functionName} ${pWSLPath} ) && actualStatusResult=$? || actualStatusResult=$? 
    # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }

  }
  fn__WSLPathToWSDPath_test_002


  testIntent="${functionName} will return __FAILED and X is not a valid WSL path"
  function fn__WSLPathToWSDPath_test_003() {
    pWSLPath="d:/gitserver/gitserver/_commonUtils/utils"
    expectedStringResult="'${pWSLPath}' is not a valid WSL path"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ${pWSLPath} ) && actualStatusResult=$? || actualStatusResult=$? 
    # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }

  }
  fn__WSLPathToWSDPath_test_003


  testIntent="${functionName} will return __FAILED and X is not a valid WSL path"
  function fn__WSLPathToWSDPath_test_004() {
    pWSLPath="d:\gitserver\gitserver\_commonUtils\utils"
    # expectedStringResult="d:/gitserver/gitserver/_commonUtils/utils"
    expectedStringResult="'${pWSLPath}' is not a valid WSL path"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ${pWSLPath} ) && actualStatusResult=$? || actualStatusResult=$? 
    # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }

  }
  fn__WSLPathToWSDPath_test_004

else 
  echo "Not running test for ${functionName}"
fi


functionName="fn__WSLPathToRealDosPath"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__WSLPathToRealDosPath \
      ${WSLPath} \
        && return ${__DONE} \
        || return ${__FAILED}
    Transform WSL path like /mnt/d/docker/test to DOS path like d:\docker\test
  Expects in environment:
    Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------

_RUN_TEST_SET_=${__YES}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __FAILURE, insufficient number of arguments and Usage message"
  function fn__WSLPathToRealDosPath_test_001() {
    expectedStringResult=""
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$? 
    # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__WSLPathToRealDosPath_test_001


  testIntent="${functionName} will return __SUCCESS and the the DOS path"
  function fn__WSLPathToRealDosPath_test_002() {
    pWSLPath="/mnt/d/gitserver/gitserver/_commonUtils/utils"
    expectedStringResult="d:\gitserver\gitserver\_commonUtils\utils"
    expectedStatusResult=${__SUCCESS}

    actualStringResult=$( ${functionName} ${pWSLPath} ) && actualStatusResult=$? || actualStatusResult=$? 
    # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }

  }
  fn__WSLPathToRealDosPath_test_002


  testIntent="${functionName} will return __FAILED and X is not a valid WSL path"
  function fn__WSLPathToRealDosPath_test_003() {
    pWSLPath="d:/gitserver/gitserver/_commonUtils/utils"
    expectedStringResult="'${pWSLPath}' is not a valid WSL path"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ${pWSLPath} ) && actualStatusResult=$? || actualStatusResult=$? 
    # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }

  }
  fn__WSLPathToRealDosPath_test_003


  testIntent="${functionName} will return __FAILED and X is not a valid WSL path"
  function fn__WSLPathToRealDosPath_test_004() {
    pWSLPath="d:\gitserver\gitserver\_commonUtils\utils"
    expectedStringResult="'${pWSLPath}' is not a valid WSL path"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ${pWSLPath} ) && actualStatusResult=$? || actualStatusResult=$? 
    # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }

  }
  fn__WSLPathToRealDosPath_test_004

else 
  echo "Not running test for ${functionName}"
fi


echo "____ Executed $((iSuccessResults+iFailureResults)) tests"
echo "____ ${iSuccessResults} tests were successful"
echo "____ ${iFailureResults} tests failed"

exit ${iFailureResults}
