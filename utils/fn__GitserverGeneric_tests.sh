#!/bin/bash
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -ur fn__GitserverGeneric_tests="SOURCED"

# common environment variable values and utility functions
#
[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__GitserverGeneric} ]] || source ./utils/fn__GitserverGeneric.sh



declare -i iSuccessResults=0
declare -i iFailureResults=0

declare functionName
declare functionInputs
declare expectedStringResult
declare expectedStatusResult
declare actualStringResult
declare actualStatusResult

declare -r _IGNORE_OUTPUT_='1>&2 2>/dev/null'

## need to work through this some more
##
functionName="fn__DoesRepoAlreadyExist"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else 
  functionInputs="gitserver gitserver git /bin/bash"
  expectedStringResult="gitserver"
  expectedStatusResult=0
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # echo "xxxxxx ${0}:${LINENO}: actualStringResult: ${actualStringResult}"
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="gitserverXX gitserver git /bin/bash"
  expectedStringResult=""
  expectedStatusResult=1
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="'gitserver' 'gitserverXX' 'git' '/bin/bash'"
  expectedStringResult=""
  expectedStatusResult=1
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # echo "xxxxxx ${0}:${LINENO}: actualStringResult: ${actualStringResult}"
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="'gitserver' 'XXgitserverXX' 'git' '/bin/bash'"
  expectedStringResult=""
  expectedStatusResult=${__NO}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="'gitserver' 'gitserver' 'XXgit' '/bin/bashXX'"
  expectedStringResult=""
  expectedStatusResult=${__NO}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="'gitserverXX' 'gitserver' 'git'"
  expectedStringResult="______ Insufficient number of arguments"
  expectedStatusResult=11
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  actualStringResult=${actualStringResult:0:${#expectedStringResult}}
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="'gitserver' 'gitserver'"
  expectedStringResult="______ Insufficient number of arguments"
  expectedStatusResult=11
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  actualStringResult=${actualStringResult:0:${#expectedStringResult}}
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

fi


functionName="fn__IsRepositoryEmpty"
if [[ true -eq true ]]; then
  echo "Not running test for ${functionName}"
else 
  functionInputs="/opt/gitrepos gitserver gitserver git /bin/bash"
  expectedStringResult="72"
  expectedStatusResult=${__SUCCESS}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="/opt/gitrepos gitserver gitserver git /bin/bash"
  expectedStringResult="0"
  expectedStatusResult=${__SUCCESS}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # we expect more than 0 so change the comparison
  [[ "${actualStringResult}" != "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="/opt/gitrepos XXgitserver gitserver git /bin/bash"
  expectedStringResult=""
  expectedStatusResult=${__FAILED}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="/opt/Xgitrepos gitserver gitserver git /bin/bash"
  expectedStringResult=""
  expectedStatusResult=${__FAILED}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="/opt/gitrepos gitserver XXgitserver git /bin/bash"
  expectedStringResult=""
  expectedStatusResult=${__FAILED}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="/opt/gitrepos gitserver gitserver XXgit /bin/bash"
  expectedStringResult="" # ignore the errormessage - return status will be failure (!=0)
  expectedStatusResult=${__FAILED}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  actualStringResult="" # ignore the error message - return status will be failure (!=0)
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="/opt/gitrepos gitserver gitserver git /xbin/bash"
  expectedStringResult="" 
  expectedStatusResult=${__FAILED}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  actualStringResult="" # ignore the error message - return status will be failure (!=0)
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="/opt/gitrepos gitserver gitserver git"
  expectedStringResult="" 
  expectedStatusResult=${__FAILED}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # actualStringResult="" # ignore the error message - return status will be failure (!=0)
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs=""
  expectedStringResult="" 
  expectedStatusResult=${__FAILED}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # actualStringResult="" # ignore the error message - return status will be failure (!=0)
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="aa"
  expectedStringResult="" 
  expectedStatusResult=${__FAILED}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  # actualStringResult="" # ignore the error message - return status will be failure (!=0)
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }
fi


functionName="fn__IsSSHToRemoteServerAuthorised"
if [[ true -eq true ]]; then
  echo "Not running test for ${functionName}"
else 
  functionInputs="gitserver git ${__GIT_HOST_PORT}"
  expectedStringResult=""
  expectedStatusResult=${__SUCCESS}
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="gitserver gixt ${__GIT_HOST_PORT}"
  expectedStringResult=""
  expectedStatusResult=255
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
  [[ "${actualStringResult}" == "${expectedStringResult}" && ${actualStatusResult} -eq ${expectedStatusResult} ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} == ${actualStringResult} (${actualStatusResult} -eq ${expectedStatusResult})" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedStringResult} != ${actualStringResult} (${actualStatusResult} -ne ${expectedStatusResult})" 
      ((iFailureResults++)); true
    }

  functionInputs="gitserver git 50021"
  expectedStringResult=""
  expectedStatusResult=255
  actualStringResult=$( ${functionName} ${functionInputs} ) && actualStatusResult=$? || actualStatusResult=$? 
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
