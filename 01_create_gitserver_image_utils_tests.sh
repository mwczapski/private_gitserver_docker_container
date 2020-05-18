# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u _01_create_gitserver_image_utils_tests="SOURCED"

[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
[[ ${fn__GitserverGeneric} ]] || source ./utils/fn__GitserverGeneric.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh

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

declare -r _TEMP_DIR_PREFIX=/tmp/$( basename ${0} )_
declare -r _TEMP_DIR_=${_TEMP_DIR_PREFIX}${gTS}

declare -i _RUN_TEST_SET_=${__NO}

# defining _FORCE_RUNNING_ALL_TESTS_ will force all test sets in this suite 
# to be executed regardless of the setting for each test set
#
#_FORCE_RUNNING_ALL_TESTS_=""

## ############################################################################
## test files
## ############################################################################

mkdir -p ${_TEMP_DIR_}


cat <<'EOF' > ${_TEMP_DIR_}/docker-entrypoint.sh_expected
#!/bin/bash

set -e
set -u

service ssh start

# prevent container from exiting after successfull startup
exec /bin/bash -c 'while true; do sleep 100000; done'
EOF


cat <<'EOF' > ${_TEMP_DIR_}/docker-entrypoint.sh_different_from_actual
#!/bin/bash

set -e
set -u

# this is different form what is expected

# service ssh start

# prevent container from exiting after successfull startup
exec /bin/bash -c 'while true; do sleep 300000; done'
EOF


cat <<'EOF' > ${_TEMP_DIR_}/Dockerfile_expected
FROM bitnami/minideb:jessie

## Dockerfile Version: 20200518_145417
##
# the environment variables below will be used in creating the image
# and will be available to the containers created from the image ...
#

ENV DEBMIN_USERNAME=git \
    DEBMIN_SHELL=/bin/bash \
    DEBMIN_SHELL_PROFILE=.bash_profile \
    GITSERVER_REPOS_ROOT=/opt/gitrepos \
    TZ_PATH=Australia/Sydney \
    TZ_NAME=Australia/Sydney  \
    ENV=/etc/profile  \
    DEBIAN_FRONTEND=noninteractive

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# install necessary / usefull extra packages
# the following are needed to download, builld and install git from sources
# wget, unzip, build-essential, libssl-dev, libcurl4-openssl-dev, libexpat1-dev, gettex
#
RUN export DEBIAN_FRONTEND=noninteractive && \
  chmod +x /usr/local/bin/docker-entrypoint.sh && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get -y install apt-utils && \
  apt-get -y install \
    tzdata \
    net-tools \
    iputils-ping \
    openssh-client \
    openssh-server \
    less \
    nano \
# the following are needed to download, builld and install git from sources
    wget \
    unzip \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    libexpat1-dev \
    gettext && \
\
# set timezone - I live in Sydney - change as you see fit in the env variables above
    cp -v /usr/share/zoneinfo/${TZ_PATH} /etc/localtime && \
    echo "${TZ_NAME}" > /etc/timezone && \
    echo $(date) && \
\
# create git user
    addgroup developers && \
    useradd -G developers -m ${DEBMIN_USERNAME} -s ${DEBMIN_SHELL} -p ${DEBMIN_USERNAME} && \
\
## configure git and ssh access to git repositories on this git server
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config && \
\
# download and install latest git
    mkdir -pv /root/Downloads/git-master && \
    cd /root/Downloads && \
    wget https://github.com/git/git/archive/master.zip -O /root/Downloads/git-master-20200518_145417.zip  && \
    unzip /root/Downloads/git-master-20200518_145417.zip && \
    cd /root/Downloads/git-master && \
    make prefix=/usr all  && \
    make prefix=/usr install  && \
    git --version && \
\
# create user's .ssh directory
    mkdir -pv /home/${DEBMIN_USERNAME}/.ssh/ && \
    touch /home/${DEBMIN_USERNAME}/.ssh/authorized_keys && \
    chmod 600 /home/${DEBMIN_USERNAME}/.ssh/authorized_keys && \
    mkdir -pv ${GITSERVER_REPOS_ROOT} && \
    chown -Rv ${DEBMIN_USERNAME}:developers ${GITSERVER_REPOS_ROOT} && \
    chmod -v g+rxs ${GITSERVER_REPOS_ROOT} && \
    echo /usr/bin/git-shell >> /etc/shells && \
    chsh git -s /usr/bin/git-shell && \
\
# remove git source and build tools
  apt-get update && \
  apt-get remove -y \
    wget \
    unzip \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    libexpat1-dev \
    gettext && \
    apt-get update && \
  apt-get autoremove -y && \
  rm -Rf /root/Downloads
EOF

cat <<'EOF' > ${_TEMP_DIR_}/Dockerfile_different_from_actual
FROM bitnami/minideb:jessie

## Dockerfile Version: 20200518_145417
##
# the environment variables below will be used in creating the image
# and will be available to the containers created from the image ...
# as if it was a good thing...
#

ENV DEBMIN_USERNAME=git \
    DEBMIN_SHELL=/bin/bash \
    DEBMIN_SHELL_PROFILE=.bash_profile \
    GITSERVER_REPOS_ROOT=/opt/gitrepos \
    TZ_PATH=Australia/Sydney \
    TZ_NAME=Australia/Sydney  \
    ENV=/etc/profile  \
    DEBIAN_FRONTEND=noninteractive

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# install necessary / usefull extra packages
# the following are needed to download, builld and install git from sources
# wget, unzip, build-essential, libssl-dev, libcurl4-openssl-dev, libexpat1-dev, gettex
#
RUN export DEBIAN_FRONTEND=noninteractive && \
  chmod +x /usr/local/bin/docker-entrypoint.sh && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get -y install apt-utils && \
  apt-get -y install \
    tzdata \
    net-tools \
    iputils-ping \
    openssh-client \
    openssh-server \
    less \
    nano \
# the following are needed to download, builld and install git from sources
    wget \
    unzip \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    libexpat1-dev \
    gettext && \
\
# set timezone - I live in Sydney - change as you see fit in the env variables above
    cp -v /usr/share/zoneinfo/${TZ_PATH} /etc/localtime && \
    echo "${TZ_NAME}" > /etc/timezone && \
    echo $(date) && \
\
# create git user
    addgroup developers && \
    useradd -G developers -m ${DEBMIN_USERNAME} -s ${DEBMIN_SHELL} -p ${DEBMIN_USERNAME} && \
\
## configure git and ssh access to git repositories on this git server
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config && \
\
# download and install latest git
    mkdir -pv /root/Downloads/git-master && \
    cd /root/Downloads && \
    wget https://github.com/git/git/archive/master.zip -O /root/Downloads/git-master-20200518_145417.zip  && \
    unzip /root/Downloads/git-master-20200518_145417.zip && \
    cd /root/Downloads/git-master && \
    make prefix=/usr all  && \
    make prefix=/usr install  && \
    git --version && \
\
# create user's .ssh directory
    mkdir -pv /home/${DEBMIN_USERNAME}/.ssh/ && \
    touch /home/${DEBMIN_USERNAME}/.ssh/authorized_keys && \
    chmod 600 /home/${DEBMIN_USERNAME}/.ssh/authorized_keys && \
    mkdir -pv ${GITSERVER_REPOS_ROOT} && \
    chown -Rv ${DEBMIN_USERNAME}:developers ${GITSERVER_REPOS_ROOT} && \
    chmod -v g+rxs ${GITSERVER_REPOS_ROOT} && \
    echo /usr/bin/git-shell >> /etc/shells && \
    chsh git -s /usr/bin/git-shell && \
\
# remove git source and build tools
  apt-get update && \
  apt-get remove -y \
    wget \
    unzip \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    libexpat1-dev \
    gettext && \
    apt-get update && \
  apt-get autoremove -y && \
  rm -Rf /root/Downloads
EOF




## ############################################################################
## test sets
## ############################################################################


functionName="fn__UpdateOwnershipOfNonRootUserResources"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__UpdateOwnershipOfNonRootUserResources  \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_GUEST_HOME}  \
      ${__GITSERVER_SHELL}  \
      ${__GITSERVER_REPOS_ROOT}
  Returns:
    ${__INSUFFICIENT_ARGS_STS}
    ${__EMPTY_ARGUMENT_NOT_ALLOWED}
    ${__INVALID_VALUE}
    ${__FAILED}
    ${__DONE}
------------Function_Usage_Note-------------------------------
_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __INSUFFICIENT_ARGS_STS completion code"
  function fn__UpdateOwnershipOfNonRootUserResources_test_001 {

    expectedStringResult=""
    expectedStatusResult=${__INSUFFICIENT_ARGS_STS}

    ${functionName} && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__UpdateOwnershipOfNonRootUserResources_test_001


  testIntent="${functionName} will return __EMPTY_ARGUMENT_NOT_ALLOWED completion code"
  function fn__UpdateOwnershipOfNonRootUserResources_test_002 {

    expectedStringResult=""
    expectedStatusResult=${__EMPTY_ARGUMENT_NOT_ALLOWED}

    ${functionName} "" "" "" "" "" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__UpdateOwnershipOfNonRootUserResources_test_002


  testIntent="${functionName} will return __EMPTY_ARGUMENT_NOT_ALLOWED completion code"
  function fn__UpdateOwnershipOfNonRootUserResources_test_003 {
    local -r pContainerName=""
    local -r pGitUsername=""
    local -r pGuestHome=""
    local -r pContainerShell=""
    local -r pGitReposRoot=""

    expectedStringResult=""
    expectedStatusResult=${__EMPTY_ARGUMENT_NOT_ALLOWED}

    ${functionName} "${pContainerName}" "${pGitUsername}" "${pGuestHome}" "${pContainerShell}" "${pGitReposRoot}" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__UpdateOwnershipOfNonRootUserResources_test_003


  testIntent="${functionName} will return __FAILED completion code - no such container"
  function fn__UpdateOwnershipOfNonRootUserResources_test_004 {
    local -r pContainerName="${__GITSERVER_CONTAINER_NAME}x"
    local -r pGitUsername="${__GIT_USERNAME}"
    local -r pGuestHome="${__GITSERVER_GUEST_HOME}"
    local -r pContainerShell="${__GITSERVER_SHELL}"
    local -r pGitReposRoot="${__GITSERVER_REPOS_ROOT}"

    expectedStringResult=""
    expectedStatusResult=${__FAILED}

    ${functionName} "${pContainerName}" "${pGitUsername}" "${pGuestHome}" "${pContainerShell}" "${pGitReposRoot}" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__UpdateOwnershipOfNonRootUserResources_test_004


else 
  echo "     . Not running test for ${functionName}" >/dev/null
fi




functionName="fn__CreateDockerfile"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__CreateDockerfile \
      "${__DEBMIN_SOURCE_IMAGE_NAME}"
      "${__GIT_USERNAME}" \
      "${__GITSERVER_SHELL}"  \
      "${__GITSERVER_SHELL_PROFILE}"  \
      "${__TZ_PATH}"  \
      "${__TZ_NAME}"  \
      "${__ENV}"  \
      "${__GITSERVER_REPOS_ROOT}" \
      "${__DOCKERFILE_PATH}"  \
      "${__NEEDS_REBUILDING}"
  Returns:
    ${__YES}  # __NEEDS_REBUILDING
    ${__NO}   # not __NEEDS_REBUILDING
    ${__INSUFFICIENT_ARGS_STS}
    ${__EMPTY_ARGUMENT_NOT_ALLOWED}
    ${__INVALID_VALUE}
------------Function_Usage_Note-------------------------------
_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __INSUFFICIENT_ARGS_STS completion code"
  function fn__CreateDockerfile_test_001 {

    expectedStringResult=""
    expectedStatusResult=${__INSUFFICIENT_ARGS_STS}

    ${functionName} && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__CreateDockerfile_test_001


  testIntent="${functionName} will return __EMPTY_ARGUMENT_NOT_ALLOWED completion code"
  function fn__CreateDockerfile_test_002 {

    expectedStringResult=""
    expectedStatusResult=${__EMPTY_ARGUMENT_NOT_ALLOWED}

    ${functionName} "" "" "" "" "" "" "" "" "" "" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__CreateDockerfile_test_002


  function fn__CreateDockerfile_test_003 {

    testIntent="${functionName} will return __NO completion code having generated a Dockerfile that is new or no different from previous version"
    function fn__TestFunctionExecution() {

      local -r lrDebminSourceImageName="${__DEBMIN_SOURCE_IMAGE_NAME}"
      local -r lrGitUsername="${__GIT_USERNAME}"
      local -r lrGitserverShell="${__GITSERVER_SHELL}"
      local -r lrGitserverShellProfile="${__GITSERVER_SHELL_PROFILE}"
      local -r lrTZPath="${__TZ_PATH}"
      local -r lrTZName="${__TZ_NAME}"
      local -r lrGlobalShellProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
      local -r lrGitserverReposRoot="${__GITSERVER_REPOS_ROOT}"
      local -r lrDockerfilePath="${_TEMP_DIR_}/Dockerfile"
      local -r lrNeedsRebuilding=${__NO}

      expectedStringResult=""
      expectedStatusResult=${__NO}

      ${functionName} \
        "${lrDebminSourceImageName}" \
        "${lrGitUsername}" \
        "${lrGitserverShell}" \
        "${lrGitserverShellProfile}" \
        "${lrTZPath}" \
        "${lrTZName}" \
        "${lrGlobalShellProfile}" \
        "${lrGitserverReposRoot}" \
        "${lrDockerfilePath}" \
        "${lrNeedsRebuilding}" && actualStatusResult=$? || actualStatusResult=$?
      actualStringResult=""
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
    fn__TestFunctionExecution


    testIntent="${functionName} will return __THE_SAME completion code having compared expected and generated Dockerfiles"
    function fn__TestFunctionOutput() {
      
      expectedStringResult=""
      expectedStatusResult=${__THE_SAME}

      local -r lExpectedFileName=${_TEMP_DIR_}/Dockerfile_expected
      local -r lActualFileName=${_TEMP_DIR_}/Dockerfile

      fn__FileSameButForDate ${lExpectedFileName} ${lActualFileName} && actualStatusResult=$? || actualStatusResult=$?
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
    fn__TestFunctionOutput

  }
  fn__CreateDockerfile_test_003


  function fn__CreateDockerfile_test_004 {

    testIntent="${functionName} will return __NO completion code having generated a Dockerfile that is new or no different from previous version"
    function fn__TestFunctionExecution() {

      local -r lrDebminSourceImageName="${__DEBMIN_SOURCE_IMAGE_NAME}"
      local -r lrGitUsername="${__GIT_USERNAME}"
      local -r lrGitserverShell="${__GITSERVER_SHELL}"
      local -r lrGitserverShellProfile="${__GITSERVER_SHELL_PROFILE}"
      local -r lrTZPath="${__TZ_PATH}"
      local -r lrTZName="${__TZ_NAME}"
      local -r lrGlobalShellProfile="${__GITSERVER_SHELL_GLOBAL_PROFILE}"
      local -r lrGitserverReposRoot="${__GITSERVER_REPOS_ROOT}"
      local -r lrDockerfilePath="${_TEMP_DIR_}/Dockerfile"
      local -r lrNeedsRebuilding=${__NO}

      expectedStringResult=""
      expectedStatusResult=${__NO}

      ${functionName} \
        "${lrDebminSourceImageName}" \
        "${lrGitUsername}" \
        "${lrGitserverShell}" \
        "${lrGitserverShellProfile}" \
        "${lrTZPath}" \
        "${lrTZName}" \
        "${lrGlobalShellProfile}" \
        "${lrGitserverReposRoot}" \
        "${lrDockerfilePath}" \
        "${lrNeedsRebuilding}" && actualStatusResult=$? || actualStatusResult=$?
      actualStringResult=""
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
    fn__TestFunctionExecution


    testIntent="${functionName} will return __DIFFERENT completion code having compared expected and generated Dockerfiles"
    function fn__TestFunctionOutput() {
      
      expectedStringResult=""
      expectedStatusResult=${__DIFFERENT}

      local -r lExpectedFileName=${_TEMP_DIR_}/Dockerfile_different_from_actual
      local -r lActualFileName=${_TEMP_DIR_}/Dockerfile

      fn__FileSameButForDate ${lExpectedFileName} ${lActualFileName} && actualStatusResult=$? || actualStatusResult=$?
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
    fn__TestFunctionOutput

  }
  fn__CreateDockerfile_test_004


else 
  echo "     . Not running test for ${functionName}" >/dev/null
fi


functionName="fn__Create_docker_entry_point_file"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__Create_docker_entry_point_file \
      ${__DEBMIN_HOME}  \
      ${__GITSERVER_SHELL}  \
        && STS=${__SUCCESS} \
        || STS=${__INSUFFICIENT_ARGS_STS}
  Returns:
    ${__SUCCESS}
    ${__INSUFFICIENT_ARGS_STS}
    ${__EMPTY_ARGUMENT_NOT_ALLOWED}
    ${__NO_SUCH_DIRECTORY}
    ${__INVALID_VALUE}
  Expects in environment:
    Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------
_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __INSUFFICIENT_ARGS_STS completion code"
  function fn__Create_docker_entry_point_file_test_001 {

    expectedStringResult=""
    expectedStatusResult=${__INSUFFICIENT_ARGS_STS}

    ${functionName} && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__Create_docker_entry_point_file_test_001


  testIntent="${functionName} will return __EMPTY_ARGUMENT_NOT_ALLOWED completion code"
  function fn__Create_docker_entry_point_file_test_002 {

    expectedStringResult=""
    expectedStatusResult=${__EMPTY_ARGUMENT_NOT_ALLOWED}

    ${functionName} "" "" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__Create_docker_entry_point_file_test_002


  testIntent="${functionName} will return __NO_SUCH_DIRECTORY completion code"
  function fn__Create_docker_entry_point_file_test_003 {
    local -r pDebminHome="/mnt/d/gitserver/gitserver/_commonUtils/abc"
    local -r pGitserverShell="/bin/sh"

    expectedStringResult=""
    expectedStatusResult=${__NO_SUCH_DIRECTORY}

    ${functionName} "${pDebminHome}" "${pGitserverShell}" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__Create_docker_entry_point_file_test_003


  testIntent="${functionName} will return __INVALID_VALUE completion code"
  function fn__Create_docker_entry_point_file_test_004 {
    local -r pDebminHome="/mnt/d/gitserver/gitserver/_commonUtils"
    local -r pGitserverShell="/bin/sh"

    expectedStringResult=""
    expectedStatusResult=${__INVALID_VALUE}

    ${functionName} "${pDebminHome}" "${pGitserverShell}" && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  fn__Create_docker_entry_point_file_test_004


  function fn__Create_docker_entry_point_file_test_005 {

    testIntent="${functionName}/fn__TestFunctionExecution will return __SUCCESS completion code"
    function fn__TestFunctionExecution() {
      local -r pDebminHome=${_TEMP_DIR_}
      local -r pGitserverShell="/bin/bash"

      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      ${functionName} "${pDebminHome}" "${pGitserverShell}" && actualStatusResult=$? || actualStatusResult=$?
      actualStringResult=""
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
    fn__TestFunctionExecution


    testIntent="${functionName}/fn__TestFunctionOutput will return __SUCCESS completion code"
    function fn__TestFunctionOutput() {
      
      local -r pDebminHome=${_TEMP_DIR_}
      local -r pGitserverShell="/bin/bash"

      expectedStringResult=""
      expectedStatusResult=${__THE_SAME}

      local -r lExpectedFileName=${_TEMP_DIR_}/docker-entrypoint.sh_expected
      local -r lActualFileName=${_TEMP_DIR_}/docker-entrypoint.sh

      fn__FileSameButForDate ${lExpectedFileName} ${lActualFileName} && actualStatusResult=$? || actualStatusResult=$?
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
    fn__TestFunctionOutput


  }
  fn__Create_docker_entry_point_file_test_005


  function fn__Create_docker_entry_point_file_test_006 {

    testIntent="${functionName}/fn__TestFunctionExecution will return __SUCCESS completion code"
    function fn__TestFunctionExecution() {
      local -r pDebminHome=${_TEMP_DIR_}
      local -r pGitserverShell="/bin/bash"

      expectedStringResult=""
      expectedStatusResult=${__SUCCESS}

      ${functionName} "${pDebminHome}" "${pGitserverShell}" && actualStatusResult=$? || actualStatusResult=$?
      actualStringResult=""
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
    fn__TestFunctionExecution


    testIntent="${functionName}/fn__TestFunctionOutput will return __DIFFERENT completion code"
    function fn__TestFunctionOutput() {
      
      local -r pDebminHome=${_TEMP_DIR_}
      local -r pGitserverShell="/bin/bash"

      expectedStringResult=""
      expectedStatusResult=${__DIFFERENT}

      local -r lExpectedFileName=${_TEMP_DIR_}/docker-entrypoint.sh_different_from_actual
      local -r lActualFileName=${_TEMP_DIR_}/docker-entrypoint.sh

      fn__FileSameButForDate ${lExpectedFileName} ${lActualFileName} && actualStatusResult=$? || actualStatusResult=$?
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
    fn__TestFunctionOutput
  }
  fn__Create_docker_entry_point_file_test_006

else 
  echo "     . Not running test for ${functionName}"
fi


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

_RUN_TEST_SET_=${__NO}
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
      [[ "${lTZPath}" != "${__TZ_PATH}" ]] && (( lMismatches++ ))
      [[ "${lTZName}" != "${__TZ_NAME}" ]] && (( lMismatches++ ))
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
      [[ "${lTZPath}" != "${__TZ_PATH}" ]] && (( lMismatches++ ))
      [[ "${lTZName}" != "${__TZ_NAME}" ]] && (( lMismatches++ ))
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
















functionName="fn__FunctionTestTemplate"
:<<-'------------Function_Usage_Note-------------------------------'
  Usage: 
    fn__FunctionTestTemplate \
      "${__SCRIPTS_DIRECTORY_NAME}" \   # by value
      "__DEBMIN_HOME"  \                # by reference
  Returns:
    ${__SUCCESS}
    ${__INSUFFICIENT_ARGS_STS} or explicit error code
  Expects in environment:
    Constants from __env_GlobalConstants
------------Function_Usage_Note-------------------------------
_RUN_TEST_SET_=${__NO}
if [[ ${_RUN_TEST_SET_} -eq ${__YES} || ${_FORCE_RUNNING_ALL_TESTS_} ]]
then

  testIntent="${functionName} will return __INSUFFICIENT_ARGS_STS and '______ Insufficient number of arguments'"
  function fn__FunctionTestTemplate_test_001 {

    expectedStringResult=""
    expectedStatusResult=${__INSUFFICIENT_ARGS_STS}

    ${functionName} && actualStatusResult=$? || actualStatusResult=$?
    actualStringResult=""
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
  # fn__FunctionTestTemplate_test_001


else 
  echo "     . Not running test for ${functionName}" >/dev/null
fi



# clean up
echo ${_TEMP_DIR_}
# rm -Rf ${_TEMP_DIR_}
# rm -rf ${_TEMP_DIR_PREFIX}[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]

echo "______ Executed $((iSuccessResults+iFailureResults)) tests"
echo "______ ${iSuccessResults} tests were successful"
echo "______ ${iFailureResults} tests failed"

exit ${iFailureResults}
