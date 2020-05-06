# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__UtilityGeneric_tests="SOURCED"

[[ ${__env_YesNoSuccessFailureContants} ]] || source __env_YesNoSuccessFailureContants.sh
[[ ${fn__UtilityGeneric} ]] || source fn__UtilityGeneric.sh

declare -i iSuccessResults=0
declare -i iFailureResults=0

declare functionName
declare functionInputs
declare expectedResult
declare actualResult

functionName="fn__IsValidRegEx"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else 
  functionInputs="[a-zA-Z]"
  expectedResult="VALID"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-z A-Z]"
  expectedResult="VALID"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-z]"
  expectedResult="VALID"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-z"
  expectedResult="______ Alleged regular expression '[a-z' must start with [ and end with ]"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="a-z]"
  expectedResult="______ Alleged regular expression 'a-z]' must start with [ and end with ]"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="a-z"
  expectedResult="______ Alleged regular expression 'a-z' must start with [ and end with ]"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="a-"
  expectedResult="______ Alleged regular expression 'a-' must be at least 3 characters long"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs=""
  expectedResult="______ Requires a shell regex to validate"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[this is a test]"
  expectedResult="VALID"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-zA-Z0-9]"
  expectedResult="VALID"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-zA-]"
  expectedResult="VALID"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

fi


functionName="fn__SanitizeInput"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else
  functionInputs="[a-zA-Z] ala_ma_kota"
  expectedResult="alamakota"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-zA-Z] 'ala ma kota'"
  expectedResult="alamakota"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-z] 'This is A Test'"
  expectedResult="hisisest"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-zA-Z _] 'This_is\ A Test'"
  expectedResult="This_is A Test"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-zA-Z ] 'This_is\ A Test'"
  expectedResult="Thisis A Test"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="[a-zA-Z_] 'This_is\ A Test'"
  expectedResult="This_isATest"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  ## +++++++++++++++++++++++++++++++++++++++++++++++++++++
fi


functionName="fn__SanitizeInputAlphaNum"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else
  functionInputs="ala_ma_kota"
  expectedResult="alamakota"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="ala ma kota_1234"
  expectedResult="alamakota1234"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="Z me@this+Place&'ala ma kota'"
  expectedResult="ZmethisPlacealamakota"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  ## +++++++++++++++++++++++++++++++++++++++++++++++++++++
fi


functionName="fn__SanitizeInputAlpha"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else
  ## --------------------------------------
  functionInputs="ala_ma_kota"
  expectedResult="alamakota"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="ala ma kota_1234"
  expectedResult="alamakota"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="Z me@this+Place&'ala ma kota'"
  expectedResult="ZmethisPlacealamakota"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  ## +++++++++++++++++++++++++++++++++++++++++++++++++++++
fi


functionName="fn__SanitizeInputNumeric"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else
  ## --------------------------------------
  functionInputs="ala_ma_kota"
  expectedResult=""
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="ala ma kota_1234"
  expectedResult="1234"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  functionInputs="Z me@this+2Place3&'4ala _\5ma k6ota'"
  expectedResult="23456"
  actualResult=$( ${functionName} ${functionInputs} )
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }

  ## +++++++++++++++++++++++++++++++++++++++++++++++++++++
fi


functionName="fn__FileSameButForDate"
if [[ !true -eq true ]]; then
  echo "Not running test for ${functionName}"
else
  echo "Ala ma kota" > /tmp/tmp_first_file
  echo "Ala ma kota" > /tmp/tmp_second_file
  functionInputs="/tmp/tmp_first_file /tmp/tmp_second_file"
  expectedResult=0
  ${functionName} ${functionInputs} && actualResult=$? || actualResult=$? 
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }
  rm /tmp/tmp_first_file /tmp/tmp_second_file

  echo "Ala ma kota" > /tmp/tmp_first_file
  echo "Ala ma kota a kot ma ale" > /tmp/tmp_second_file
  functionInputs="/tmp/tmp_first_file /tmp/tmp_second_file"
  expectedResult=1
  lMsg=$(${functionName} ${functionInputs}) && actualResult=$? || actualResult=$? 
  [[ ${lMsg} ]] && echo "________ ${LINENO}: ${functionName}: ${lMsg}" 
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }
  rm /tmp/tmp_first_file /tmp/tmp_second_file

  echo "Ala ma kota" > /tmp/tmp_first_file
  functionInputs="/tmp/tmp_first_file"
  expectedResult=1
  lMsg=$(${functionName} ${functionInputs}) && actualResult=$? || actualResult=$? 
  [[ ${lMsg} ]] && echo "________ ${LINENO}: ${functionName}: ${lMsg}" 
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }
  rm /tmp/tmp_first_file

  functionInputs=" "
  expectedResult=1
  lMsg=$(${functionName} ${functionInputs}) && actualResult=$? || actualResult=$? 
  [[ ${lMsg} ]] && echo "________ ${LINENO}: ${functionName}: ${lMsg}" 
  [[ "${actualResult}" == "${expectedResult}" ]] && {
      echo "SUCCESS  ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} == ${actualResult}" 
      ((iSuccessResults++)); true
    } || {
      echo "FAILIURE ${LINENO}: ${functionName}: ${functionInputs} => ${expectedResult} != ${actualResult}" 
      ((iFailureResults++)); true
    }



  ## +++++++++++++++++++++++++++++++++++++++++++++++++++++
fi

echo "______ Executed $((iSuccessResults+iFailureResults)) tests"
echo "______ ${iSuccessResults} tests were successful"
echo "______ ${iFailureResults} tests failed"

exit ${iFailureResults}
