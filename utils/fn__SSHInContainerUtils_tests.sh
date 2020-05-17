# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh

[[ ${bash_test_utils} ]] || source ./bash_test_utils/bash_test_utils.sh


[[ ${fn__SSHInContainerUtils} ]] || source ./utils/fn__SSHInContainerUtils.sh

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




functionName="fn__GenerateSSHKeyPairInClientContainer"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage:
    fn__GenerateSSHKeyPairInClientContainer \
      ${__GIT_CLIENT_CONTAINER_NAME} \
      ${__GIT_CLIENT_USERNAME} \
      ${__GIT_CLIENT_SHELL} \
      "__GIT_CLIENT_ID_RSA_PUB_" \
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
  function fn__GenerateSSHKeyPairInClientContainer_test_001 {
    local -r pClientContainerName="gitclient"
    local -r pClientUsername="gitclient"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="${__INSUFFICIENT_ARGS}"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$?
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
  fn__GenerateSSHKeyPairInClientContainer_test_001


  testIntent="${functionName} function will return __SUCCESS and the content of the generated ~/.ssh/id_rsa.pub"
  function fn__GenerateSSHKeyPairInClientContainer_test_002 {
    local -r pClientContainerName="gitclient"
    local -r pClientUsername="gitclient"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="ssh-rsa ${pClientUsername}@${pClientContainerName}"
    expectedStatusResult=${__SUCCESS}

    ${functionName} "${pClientContainerName}" "${pClientUsername}" "${pShellInContainer}" "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    outValue="${outValue%% *} ${outValue##* }"

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__GenerateSSHKeyPairInClientContainer_test_002


  testIntent="${functionName} function will return __FAILED - unable to find user xxxxx: no matching entries in passwd file"
  function fn__GenerateSSHKeyPairInClientContainer_test_003 {
    local -r pClientContainerName="gitclient"
    local -r pClientUsername="gitclientXXX"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="unable to find user gitclientXXX: no matching entries in passwd file"
    expectedStatusResult=${__FAILED}

    ${functionName} "${pClientContainerName}" "${pClientUsername}" "${pShellInContainer}" "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__GenerateSSHKeyPairInClientContainer_test_003

else 
  echo "     . Not running test for ${functionName}"
fi


functionName="fn__GetSSHIdRsaPubKeyFromClientContainer"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__GetSSHIdRsaPubKeyFromClientContainer \
      ${__GIT_CLIENT_CONTAINER_NAME} \
      ${__GIT_CLIENT_USERNAME} \
      ${__GIT_CLIENT_SHELL} \
      "__GIT_CLIENT_ID_RSA_PUB_" \
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
  function fn__GetSSHIdRsaPubKeyFromClientContainer_test_001 {
    local -r pClientContainerName="gitclient"
    local -r pClientUsername="gitclient"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="${__INSUFFICIENT_ARGS}"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$?
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
  fn__GetSSHIdRsaPubKeyFromClientContainer_test_001


  testIntent="${functionName} function will return __SUCCESS and the content of the ~/.ssh/id_rsa.pub"
  function fn__GetSSHIdRsaPubKeyFromClientContainer_test_002 {
    local -r pClientContainerName="gitclient"
    local -r pClientUsername="gitclient"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="ssh-rsa ${pClientUsername}@${pClientContainerName}"
    expectedStatusResult=${__SUCCESS}

    ${functionName} "${pClientContainerName}" "${pClientUsername}" "${pShellInContainer}" "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    outValue="${outValue%% *} ${outValue##* }"

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__GetSSHIdRsaPubKeyFromClientContainer_test_002


  testIntent="${functionName} function will return __FAILED - unable to find user xxxxx: no matching entries in passwd file"
  function fn__GetSSHIdRsaPubKeyFromClientContainer_test_003 {
    local -r pClientContainerName="gitclient"
    local -r pClientUsername="gitclientXXX"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="unable to find user gitclientXXX: no matching entries in passwd file"
    expectedStatusResult=${__FAILED}

    ${functionName} "${pClientContainerName}" "${pClientUsername}" "${pShellInContainer}" "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__GetSSHIdRsaPubKeyFromClientContainer_test_003

else 
  echo "     . Not running test for ${functionName}"
fi


functionName="fn__IntroduceRemoteClientToServerWithPublicKey"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage:
    fn__IntroduceRemoteClientToServerWithPublicKey \
      ${__GIT_CLIENT_CONTAINER_NAME} \
      ${__GIT_CLIENT_USERNAME} \
      ${__GIT_CLIENT_ID_RSA_PUB_}  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
  Returns:
      ${__DONE}
      ${__FAILED}
    Expects in environment:
      Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------

_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  declare -r lClientContainerName="gitclient"
  declare -r lClientUsername="gitclient"
  declare -r lShellInContainer="/bin/bash"
  declare __GIT_CLIENT_ID_RSA_PUB_=""

  fn__GetSSHIdRsaPubKeyFromClientContainer \
    ${lClientContainerName} \
    ${lClientUsername} \
    ${lShellInContainer} \
    "__GIT_CLIENT_ID_RSA_PUB_" && STS=${__DONE} || STS=${__FAILED}

  if [[ ${STS} -eq ${__FAILED} ]]
  then
    echo "!!!! ${0}:${LINENO}: fn__GetSSHIdRsaPubKeyFromClientContainer returned error '${__GIT_CLIENT_ID_RSA_PUB_}'"
    echo "!!!! ${0}:${LINENO}: Aborting test run"
    exit ${__FAILED}
  fi


  testIntent="${functionName} function will return __FAILURE, insufficient number of arguments and Usage message"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_001 {
    local -r pClientContainerName="gitclient"
    local -r pGitClientUsername="gitclient"
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"
    local outValue=""

    expectedStringResult="${__INSUFFICIENT_ARGS}"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$?
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
  fn__IntroduceRemoteClientToServerWithPublicKey_test_001


  testIntent="${functionName} function will return __FAILED trying to add empty public key to git server's ~/.ssh/authorized_keys"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_002 {
    local -r pClientContainerName="gitclient"
    local -r pGitClientUsername="gitclient"
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="____ Client id_rsa.pub public key must not be empty"
    expectedStatusResult=${__FAILED}

      # "${__GIT_CLIENT_ID_RSA_PUB_}" \
    actualResultString=$( \
      ${functionName} \
        "${pClientContainerName}" \
        "${pGitClientUsername}" \
        "" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceRemoteClientToServerWithPublicKey_test_002


  testIntent="${functionName} function will return __SUCCESS after adding client's id_rsa.pub public key to git server's ~/.ssh/authorized_keys"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_003 {
    local -r pClientContainerName="gitclient"
    local -r pGitClientUsername="gitclient"
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult=""
    expectedStatusResult=${__SUCCESS}

    ${functionName} \
      "${pClientContainerName}" \
      "${pGitClientUsername}" \
      "${__GIT_CLIENT_ID_RSA_PUB_}" \
      "${pServerContainerName}" \
      "${pGitServerGitUsername}" \
      "${pShellInServerContainer}" && actualStatusResult=$? || actualStatusResult=$?

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceRemoteClientToServerWithPublicKey_test_003


  testIntent="${functionName} function will return __FAILURE - invalid rsa public key or username mismatch"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_004 {
    local -r pClientContainerName="gitclient"
    local -r pGitClientUsername="gitclient"
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="____ Client rsa public key invalid, or username or container name mismatch"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${pClientContainerName}" \
        "${pGitClientUsername}" \
        "ala ma kota a kot ma ale" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceRemoteClientToServerWithPublicKey_test_004


  testIntent="${functionName} function will return __FAILURE - trying inappropriate container name"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_005 {
    local -r pClientContainerName="gitclientXXX"
    local -r pGitClientUsername="gitclient"
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="____ Client rsa public key invalid, or username or container name mismatch"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${pClientContainerName}" \
        "${pGitClientUsername}" \
        "${__GIT_CLIENT_ID_RSA_PUB_}" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceRemoteClientToServerWithPublicKey_test_005


  testIntent="${functionName} function will return __FAILURE - client username does not match username in id_rsa.pub"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_006 {
    local -r pClientContainerName="gitclient"
    local -r pGitClientUsername="gitclientXXX"
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="____ Client rsa public key invalid, or username or container name mismatch"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${pClientContainerName}" \
        "${pGitClientUsername}" \
        "${__GIT_CLIENT_ID_RSA_PUB_}" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceRemoteClientToServerWithPublicKey_test_006


  testIntent="${functionName} function will return __FAILURE - unknown server container name"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_009 {
    local -r pClientContainerName="gitclient"
    local -r pGitClientUsername="gitclient"
    local -r pServerContainerName="gitserverXXX"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="Error: No such container: ${pServerContainerName}"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${pClientContainerName}" \
        "${pGitClientUsername}" \
        "${__GIT_CLIENT_ID_RSA_PUB_}" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceRemoteClientToServerWithPublicKey_test_009


  testIntent="${functionName} function will return __FAILURE - unknown server username"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_007 {
    local -r pClientContainerName="gitclient"
    local -r pGitClientUsername="gitclient"
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="gitXXX"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="unable to find user ${pGitServerGitUsername}"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${pClientContainerName}" \
        "${pGitClientUsername}" \
        "${__GIT_CLIENT_ID_RSA_PUB_}" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceRemoteClientToServerWithPublicKey_test_007


  testIntent="${functionName} function will return __FAILURE - unknown server shell binary"
  function fn__IntroduceRemoteClientToServerWithPublicKey_test_008 {
    local -r pClientContainerName="gitclient"
    local -r pGitClientUsername="gitclient"
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bashcowski"

    expectedStringResult="OCI runtime exec failed"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${pClientContainerName}" \
        "${pGitClientUsername}" \
        "${__GIT_CLIENT_ID_RSA_PUB_}" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceRemoteClientToServerWithPublicKey_test_008


else 
  echo "     . Not running test for ${functionName}"
fi




functionName="fn__GetWSLClientsPublicKeyFromServer"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__GetWSLClientsPublicKeyFromServer \
      ${__GITSERVER_HOST_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
      "__GIT_CLIENT_ID_RSA_PUB_"
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
  function fn__GetWSLClientsPublicKeyFromServer_test_001 {
    local -r pGitserverName="gitserver"
    local -r pGitUsername="git"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="${__INSUFFICIENT_ARGS}"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$?
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
  fn__GetWSLClientsPublicKeyFromServer_test_001


  testIntent="${functionName} function will return __SUCCESS and the content of the server's ~/.ssh/authorized_key for local user"
  function fn__GetWSLClientsPublicKeyFromServer_test_002 {
    local -r pGitserverName="gitserver"
    local -r pGitUsername="git"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="ssh-rsa ${USER}@${NAME}"
    expectedStatusResult=${__SUCCESS}

    ${functionName} "${pGitserverName}" "${pGitUsername}" "${pShellInContainer}" "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    outValue="${outValue%% *} ${outValue##* }"

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__GetWSLClientsPublicKeyFromServer_test_002


  testIntent="${functionName} function will return __FAILED - unable to find user xxxxx: no matching entries in passwd file"
  function fn__GetWSLClientsPublicKeyFromServer_test_003 {
    local -r pGitserverName="gitserver"
    local -r pGitUsername="gitXXX"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="unable to find user gitXXX: no matching entries in passwd file"
    expectedStatusResult=${__FAILED}

    ${functionName} "${pGitserverName}" "${pGitUsername}" "${pShellInContainer}" "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__GetWSLClientsPublicKeyFromServer_test_003

else 
  echo "     . Not running test for ${functionName}"
fi


functionName="fn__GenerateSSHKeyPairInWSLHost"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__GenerateSSHKeyPairInWSLHost \
      "__GIT_CLIENT_ID_RSA_PUB_" \
        && return ${__DONE} \
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
  function fn__GenerateSSHKeyPairInWSLHost_test_001 {
    local outValue=""

    expectedStringResult="${__INSUFFICIENT_ARGS}"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$?
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
  fn__GenerateSSHKeyPairInWSLHost_test_001


  testIntent="${functionName} function will return __SUCCESS and the content of the generated ~/.ssh/id_rsa.pub"
  function fn__GenerateSSHKeyPairInWSLHost_test_002 {
    local outValue=""

    expectedStringResult="ssh-rsa ${USER}@${NAME}"
    expectedStatusResult=${__SUCCESS}

    ${functionName} "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    outValue="${outValue%% *} ${outValue##* }"

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__GenerateSSHKeyPairInWSLHost_test_002


  testIntent="${functionName} function will return __SUCCESS and the the local and remote public keys should match"
  function fn__GenerateSSHKeyPairInWSLHost_test_003 {
    local outValue=""

    fn__GetSSHIdRsaPubKeyFromLocalWSLHost "outValue" && actualStatusResult=$? || actualStatusResult=$?




    # expectedStringResult="ssh-rsa ${USER}@${NAME}"
    # expectedStatusResult=${__SUCCESS}

    # ${functionName} "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    # outValue="${outValue%% *} ${outValue##* }"

    # assessReturnStatusAndStdOut \
    #   "${functionName}" \
    #   ${LINENO} \
    #   "${testIntent}" \
    #   "${expectedStringResult}" \
    #   ${expectedStatusResult} \
    #   "${outValue}" \
    #   ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  # fn__GenerateSSHKeyPairInWSLHost_test_003

else 
  echo "     . Not running test for ${functionName}"
fi



functionName="fn__GetSSHIdRsaPubKeyFromLocalWSLHost"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__GetSSHIdRsaPubKeyFromLocalWSLHost \
      "__GIT_CLIENT_ID_RSA_PUB_" \
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
  function fn__GetSSHIdRsaPubKeyFromLocalWSLHost_test_001 {
    local outValue=""

    expectedStringResult="${__INSUFFICIENT_ARGS}"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$?
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
  fn__GetSSHIdRsaPubKeyFromLocalWSLHost_test_001


  testIntent="${functionName} function will return __SUCCESS and the content of the ~/.ssh/id_rsa.pub"
  function fn__GetSSHIdRsaPubKeyFromLocalWSLHost_test_002 {
    local outValue=""

    expectedStringResult="ssh-rsa ${USER}@${NAME}"
    expectedStatusResult=${__SUCCESS}

    ${functionName} "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    outValue="${outValue%% *} ${outValue##* }"

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__GetSSHIdRsaPubKeyFromLocalWSLHost_test_002


  testIntent="${functionName} function will return __FAILED - unable to find user xxxxx: no matching entries in passwd file"
  function fn__GetSSHIdRsaPubKeyFromLocalWSLHost_test_003 {
    local -r pClientContainerName="gitclient"
    local -r pClientUsername="gitclientXXX"
    local -r pShellInContainer="/bin/bash"
    local outValue=""

    expectedStringResult="unable to find user gitclientXXX: no matching entries in passwd file"
    expectedStatusResult=${__FAILED}

    ${functionName} "${pClientContainerName}" "${pClientUsername}" "${pShellInContainer}" "outValue" && actualStatusResult=$? || actualStatusResult=$?
    # [[ ${outValue} ]] && echo "______ ${LINENO}: ${functionName}: ${outValue}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${outValue}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  # fn__GetSSHIdRsaPubKeyFromLocalWSLHost_test_003

else 
  echo "     . Not running test for ${functionName}"
fi



functionName="fn__IntroduceLocalWSLClientToServerWithPublicKey"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage:
    fn__IntroduceLocalWSLClientToServerWithPublicKey \
      ${__GIT_CLIENT_ID_RSA_PUB_}  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
  Returns:
      ${__DONE}
      ${__FAILED}
    Expects in environment:
      Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------

_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  declare __GIT_CLIENT_ID_RSA_PUB_=""

  fn__GetSSHIdRsaPubKeyFromLocalWSLHost \
    "__GIT_CLIENT_ID_RSA_PUB_" && STS=${__DONE} || STS=${__FAILED}
  
  if [[ ${STS} -eq ${__FAILED} ]]
  then
    echo "!!!! ${0}:${LINENO}: fn__GetSSHIdRsaPubKeyFromLocalWSLHost returned error '${__GIT_CLIENT_ID_RSA_PUB_}'"
    echo "!!!! ${0}:${LINENO}: Aborting test run"
    exit ${__FAILED}
  fi

 
  testIntent="${functionName} function will return __FAILURE, insufficient number of arguments and Usage message"
  function fn__IntroduceLocalWSLClientToServerWithPublicKey_test_001 {
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"
    local outValue=""

    expectedStringResult="${__INSUFFICIENT_ARGS}"
    expectedStatusResult=${__FAILED}

    actualStringResult=$( ${functionName} ) && actualStatusResult=$? || actualStatusResult=$?
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
  fn__IntroduceLocalWSLClientToServerWithPublicKey_test_001


  testIntent="${functionName} function will return __FAILED trying to add empty public key to git server's ~/.ssh/authorized_keys"
  function fn__IntroduceLocalWSLClientToServerWithPublicKey_test_002 {
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="____ Client id_rsa.pub public key must not be empty"
    expectedStatusResult=${__FAILED}

      # "${__GIT_CLIENT_ID_RSA_PUB_}" \
    actualResultString=$( \
      ${functionName} \
        "${pClientContainerName}" \
        "${pGitClientUsername}" \
        "" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceLocalWSLClientToServerWithPublicKey_test_002


  testIntent="${functionName} function will return __SUCCESS after adding client's id_rsa.pub public key to git server's ~/.ssh/authorized_keys"
  function fn__IntroduceLocalWSLClientToServerWithPublicKey_test_003 {
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult=""
    expectedStatusResult=${__SUCCESS}
    actualStringResult=""

    ${functionName} \
      "${__GIT_CLIENT_ID_RSA_PUB_}" \
      "${pServerContainerName}" \
      "${pGitServerGitUsername}" \
      "${pShellInServerContainer}" && actualStatusResult=$? || actualStatusResult=$?

    # echo "${LINENO}: __GIT_CLIENT_ID_RSA_PUB_: ${__GIT_CLIENT_ID_RSA_PUB_}"
    declare sshPubKeyOnGitserver=""
    fn__GetWSLClientsPublicKeyFromServer \
      "${pServerContainerName}" \
      "${pGitServerGitUsername}" \
      "${pShellInServerContainer}" \
      "sshPubKeyOnGitserver" && STS=$? || STS=$?

    if [[ ${STS} -eq ${__SUCCESS} ]]
    then
      if [[ "${__GIT_CLIENT_ID_RSA_PUB_}" != "${sshPubKeyOnGitserver}" ]]
      then
        expectedStatusResult=${__FAILED}
        actualStringResult="Submitted public key and retrieved publick key are different - investigate"
      fi
    fi

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualStringResult}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }

    # echo "~~~C~ "
    # echo "~~~C~ ${__GIT_CLIENT_ID_RSA_PUB_}"
    # echo "~~~S~ "
    # echo "~~~S~ ${sshPubKeyOnGitserver}"
    # echo "~~~~~ "


  }
  fn__IntroduceLocalWSLClientToServerWithPublicKey_test_003


  testIntent="${functionName} function will return __FAILURE - invalid rsa public key or username mismatch"
  function fn__IntroduceLocalWSLClientToServerWithPublicKey_test_004 {
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="____ Client rsa public key invalid, or username or container name mismatch"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "ala ma kota a kot ma ale" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceLocalWSLClientToServerWithPublicKey_test_004


  testIntent="${functionName} function will return __FAILURE - unknown server container name"
  function fn__IntroduceLocalWSLClientToServerWithPublicKey_test_007 {
    local -r pServerContainerName="gitserverXXX"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="Error: No such container: ${pServerContainerName}"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${__GIT_CLIENT_ID_RSA_PUB_}" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceLocalWSLClientToServerWithPublicKey_test_007


  testIntent="${functionName} function will return __FAILURE - unknown server username"
  function fn__IntroduceLocalWSLClientToServerWithPublicKey_test_008 {
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="gitXXX"
    local -r pShellInServerContainer="/bin/bash"

    expectedStringResult="unable to find user ${pGitServerGitUsername}"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${__GIT_CLIENT_ID_RSA_PUB_}" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceLocalWSLClientToServerWithPublicKey_test_008


  testIntent="${functionName} function will return __FAILURE - unknown server shell binary"
  function fn__IntroduceLocalWSLClientToServerWithPublicKey_test_009 {
    local -r pServerContainerName="gitserver"
    local -r pGitServerGitUsername="git"
    local -r pShellInServerContainer="/bin/bashcowski"

    expectedStringResult="OCI runtime exec failed"
    expectedStatusResult=${__FAILED}

    actualResultString=$( \
      ${functionName} \
        "${__GIT_CLIENT_ID_RSA_PUB_}" \
        "${pServerContainerName}" \
        "${pGitServerGitUsername}" \
        "${pShellInServerContainer}" ) && actualStatusResult=$? || actualStatusResult=$?

    # [[ ${actualResultString} ]] && echo "______ ${LINENO}: ${functionName}: (${actualStatusResult}) ${actualResultString}" 

    assessReturnStatusAndStdOut \
      "${functionName}" \
      ${LINENO} \
      "${testIntent}" \
      "${expectedStringResult}" \
      ${expectedStatusResult} \
      "${actualResultString}" \
      ${actualStatusResult} && { ((iSuccessResults++)); true ; } || { ((iFailureResults++)); true ; }
  }
  fn__IntroduceLocalWSLClientToServerWithPublicKey_test_009

else 
  echo "     . Not running test for ${functionName}"
fi





# clean up
# rm -rfv ${_TEMP_DIR_PREFIX}[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]
rm -Rf ${_TEMP_DIR_}

echo "______ Executed $((iSuccessResults+iFailureResults)) tests"
echo "______ ${iSuccessResults} tests were successful"
echo "______ ${iFailureResults} tests failed"

exit ${iFailureResults}
