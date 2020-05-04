
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__ConfirmYN="SOURCED"

[[ ${__env_YesNoSuccessFailureContants} ]] || source __env_YesNoSuccessFailureContants.sh

_PROMPTS_TIMEOUT_SECS_=${_PROMPTS_TIMEOUT_SECS_:-5.5}

function fn__ConfirmYN() {
  pPrompt=${1?"Usage: $0 requires the prompt string and will return 0 if response is Yes, and 1 if it is No"}
  read -t ${_PROMPTS_TIMEOUT_SECS_} -p "______ ${pPrompt} (y/N) " -i 'No' -r RESP || echo
  RESP=${RESP^^}; RESP=${RESP:0:1}
  [[ $RESP == 'Y' ]] && return ${__YES} || return ${__NO}
}