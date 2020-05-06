# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__WSLPathToDOSandWSDPaths_tests="SOURCED"

[[ ${__env_YesNoSuccessFailureContants} ]] || source __env_YesNoSuccessFailureContants.sh
[[ ${fn__WSLPathToDOSandWSDPaths} ]] || source fn__WSLPathToDOSandWSDPaths.sh

declare -i iSuccessResults=0
declare -i iFailureResults=0

declare functionName
declare functionInputs
declare expectedStringResult
declare expectedStatusResult
declare actualStringResult
declare actualStatusResult


functionName="fn__WSLPathToWSDPath"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else 
  functionInputs="/mnt/d/gitserver/gitserver/_commonUtils/utils"
  expectedStringResult="d:/gitserver/gitserver/_commonUtils/utils"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="d:/gitserver/gitserver/_commonUtils/utils"
  expectedStringResult="d:/gitserver/gitserver/_commonUtils/utils"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="d:\gitserver\gitserver\_commonUtils\utils"
  expectedStringResult="d:\gitserver\gitserver\_commonUtils\utils"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="\gitserver/gitserver\_commonUtils/utils"
  expectedStringResult="\gitserver/gitserver\_commonUtils/utils"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs=""
  expectedStringResult=""
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

fi


functionName="fn__WSLPathToRealDosPath"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else 
  functionInputs="/mnt/d/gitserver/gitserver/_commonUtils/utils"
  expectedStringResult="d:\gitserver\gitserver\_commonUtils\utils"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="d:/gitserver/gitserver/_commonUtils/utils"
  expectedStringResult="d:\gitserver\gitserver\_commonUtils\utils"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="d:\gitserver\gitserver\_commonUtils\utils"
  expectedStringResult="d:\gitserver\gitserver\_commonUtils\utils"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="\gitserver/gitserver\_commonUtils/utils"
  expectedStringResult="\gitserver\gitserver\_commonUtils\utils"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs=""
  expectedStringResult=""
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # [[ ${actualStringResult} ]] && echo "________ ${LINENO}: ${functionName}: ${actualStringResult}" 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

fi

echo "______ Executed $((iSuccessResults+iFailureResults)) tests"
echo "______ ${iSuccessResults} tests were successful"
echo "______ ${iFailureResults} tests failed"

exit ${iFailureResults}
