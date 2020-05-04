# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__FileSameButForDate="SOURCED"

[[ ${__env_YesNoSuccessFailureContants} ]] || source __env_YesNoSuccessFailureContants.sh

function fn__FileSameButForDate() {
  local lUsage='
      Usage: 
        fnUpdateOwnershipOfNonRootUserResources  \
          ${__DOCKERFILE_PATH} \
          ${__DOCKERFILE_PATH}_${TS} \
      '
  [[ $# -lt  2 || ${0^^} == "HELP" ]] && {
    echo ${lUsage}
    return ${__FAILED}
  }

  local pFile1=${1?"${lUsage}"}
  local pFile2=${2?"${lUsage}"}

  diff -s --ignore-matching-lines='202[0-9][0-1][0-9][0-3][0-9]' \
    ${pFile1} \
    ${pFile2} \
    >/dev/null \
      && return ${__THE_SAME} \
      || return ${__DIFFERENT}
}
