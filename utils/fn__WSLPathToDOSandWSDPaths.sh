# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__WSLPathToDOSandWSDPaths="SOURCED"

# common environment variable values and utility functions
#
[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh


function fn__WSLPathToRealDosPath() { 
  local -r lUsage='
  Usage: 
    fn__WSLPathToRealDosPath \
      ${WSLPath} \
        && return ${__DONE} \
        || return ${__FAILED}
    Transform WSL path like /mnt/d/docker/test to DOS path like d:\docker\test
  '
  [[ $# -lt  1 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }
 
  local -r pWSLPath="${1}"
  [[ -n ${pWSLPath} ]] || { echo -e "____ WSL Path to transform must not be empty\n${lUsage}"; return ${__FAILED} ; }

  local -r lrHasMntWillBeEmpty=${pWSLPath%%/mnt/[a-z]/*}
  [[ ! -n ${lrHasMntWillBeEmpty} ]] || { echo "'${pWSLPath}' is not a valid WSL path" ; return ${__FAILED} ; }

  echo ${pWSLPath} | sed 's|/mnt/\(.\)|\1:|;s|/|\\|g'; 
  return ${__DONE}
}



function fn__WSLPathToWSDPath() { 
  local -r lUsage='
  Usage: 
    fn__WSLPathToWSDPath \
      ${WSLPath} \
        && return ${__DONE} \
        || return ${__FAILED}
    Transform WSL path like /mnt/d/docker/test to pseudo-DOS path like d:/docker/test
  '
  [[ $# -lt  1 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }

  local -r pWSLPath="${1}"
  [[ -n ${pWSLPath} ]] || { echo -e "____ WSL Path to transform must not be empty\n${lUsage}"; return ${__FAILED} ; }

  local -r lrHasMntWillBeEmpty=${pWSLPath%%/mnt/[a-z]/*}
  [[ ! -n ${lrHasMntWillBeEmpty} ]] || { echo "'${pWSLPath}' is not a valid WSL path" ; return ${__FAILED} ; }

  echo ${pWSLPath} | sed 's|/mnt/\(.\)|\1:|'; 

  return ${_SUCCESS}
}