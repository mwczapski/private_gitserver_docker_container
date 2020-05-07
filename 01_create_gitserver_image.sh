#!/bin/bash

###############################################
## The MIT License (MIT)
##
## Copyright © 2020 Michael Czapski
###############################################

set -o pipefail
set -o errexit

traperr() {
  echo "ERROR: ------------------------------------------------"
  echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
  echo "ERROR: ------------------------------------------------"
}
set -o errtrace
trap traperr ERR

# common environment variable values and utility functions
#
[[ ${__env_YesNoSuccessFailureContants} ]] || source ./utils/__env_YesNoSuccessFailureContants.sh
[[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
[[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh
[[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh

[[ ${fn__ConfirmYN} ]] || source ./utils/fn__ConfirmYN.sh
# [[ ${fn__FileSameButForDate} ]] || source ./utils/fn__FileSameButForDate.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh
[[ ${fn__WSLPathToDOSandWSDPaths} ]] || source ./utils/fn__WSLPathToDOSandWSDPaths.sh


[[ ${fn__CreateWindowsShortcut} ]] || source ./utils/fn__CreateWindowsShortcut.sh


## local functions
##
function fn__SetEnvironmentVariables() {

  # set environment
  #
  mkdir -pv ${__DEBMIN_HOME}
  cd ${__DEBMIN_HOME}

  __DEBMIN_HOME=${__DEBMIN_HOME%%/_commonUtils} # strip _commonUtils
  __DEBMIN_HOME_DOS=$(fn__WSLPathToRealDosPath ${__DEBMIN_HOME})
  __DEBMIN_HOME_WSD=$(fn__WSLPathToWSDPath ${__DEBMIN_HOME})
  __DEBMIN_SOURCE_IMAGE_NAME="bitnami/minideb:jessie"
  __TZ_PATH=Australia/Sydney
  __TZ_NAME=Australia/Sydney
  __ENV="${__GITSERVER_SHELL_GLOBAL_PROFILE}"

  __DOCKERFILE_PATH=${__DEBMIN_HOME}/Dockerfile.${__GITSERVER_IMAGE_NAME}

  ## toggles 
  __REMOVE_CONTAINER_ON_STOP=${__YES} # container started using this image is nto supposed to be used for work
  __NEEDS_REBUILDING=${__NO}  # set to ${__YES} if image does not exist of Dockerfile changed

}


function fn__Create_docker_entry_point_file() {

    local lUsage='
Usage: 
    fn__Create_docker_entry_point_file \
      ${__GITSERVER_SHELL}
'
  [[ $# -lt  1 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }
 
  local pGuestShell=${1?"Full path to guest's shell binary, for example /bin/bash or /bin/ash or /bin/sh"}

  cat <<-EOF > ${__DEBMIN_HOME}/docker-entrypoint.sh
#!/bin/bash
set -e

# prevent container from exiting after successfull startup
# exec /bin/bash -c 'while true; do sleep 100000; done'
exec ${pGuestShell} \$@
EOF
  chmod +x ${__DEBMIN_HOME}/docker-entrypoint.sh
}


function fn__CreateDockerfile() {

  # create Dockerfile
  local __NEEDS_REBUILDING=${__NO}
  local STS=${__SUCCESS}

  local TS=$(date '+%Y%m%d_%H%M%S')
  [[ -e ${__DOCKERFILE_PATH} ]] && cp ${__DOCKERFILE_PATH} ${__DOCKERFILE_PATH}_${TS}
    
  cat <<-EOF > ${__DOCKERFILE_PATH}
FROM ${__DEBMIN_SOURCE_IMAGE_NAME}

## Dockerfile Version: ${TS}
##
# the environment variables below will be used in creating the image
# and will be available to the containers created from the image ...
#
ENV DEBMIN_USERNAME=${__GIT_USERNAME} \\
    DEBMIN_SHELL=${__GITSERVER_SHELL} \\
    DEBMIN_SHELL_PROFILE=${__GITSERVER_SHELL_PROFILE} \\
    GITSERVER_REPOS_ROOT=${__GITSERVER_REPOS_ROOT} \\
    TZ_PATH=${__TZ_PATH} \\
    TZ_NAME=${__TZ_NAME}  \\
    ENV=${__ENV}  \\
    DEBIAN_FRONTEND=noninteractive

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# install necessary / usefull extra packages
# the following are needed to download, builld and install git from sources
# wget, unzip, build-essential, libssl-dev, libcurl4-openssl-dev, libexpat1-dev, gettex
#
RUN export DEBIAN_FRONTEND=noninteractive && \\
  apt-get update && \\
  apt-get upgrade -y && \\
  apt-get -y install apt-utils && \\
  apt-get -y install \\
    tzdata \\
    net-tools \\
    iputils-ping \\
    openssh-client \\
    openssh-server \\
    less \\
    nano \\
# the following are needed to download, builld and install git from sources
    wget \\
    unzip \\
    build-essential \\
    libssl-dev \\
    libcurl4-openssl-dev \\
    libexpat1-dev \\
    gettext && \\
\\
# set timezone - I live in Sydney - change as you see fit in the env variables above
    cp -v /usr/share/zoneinfo/\${TZ_PATH} /etc/localtime && \\
    echo "\${TZ_NAME}" > /etc/timezone && \\
    echo \$(date) && \\
\\
# create git user
    addgroup developers && \\
    useradd -G developers -m \${DEBMIN_USERNAME} -s \${DEBMIN_SHELL} -p \${DEBMIN_USERNAME} && \\
\\
## configure git and ssh access to git repositories on this git server
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config && \\
\\
# download and install latest git
    mkdir -pv /root/Downloads/git-master && \\
    cd /root/Downloads && \\
    wget https://github.com/git/git/archive/master.zip -O /root/Downloads/git-master-${TS}.zip  && \\
    unzip /root/Downloads/git-master-${TS}.zip && \\
    cd /root/Downloads/git-master && \\
    make prefix=/usr all  && \\
    make prefix=/usr install  && \\
    git --version && \\
\\
# create user's .ssh directory
    mkdir -pv /home/\${DEBMIN_USERNAME}/.ssh/ && \\
    touch /home/\${DEBMIN_USERNAME}/.ssh/authorized_keys && \\
    chmod 600 /home/\${DEBMIN_USERNAME}/.ssh/authorized_keys && \\
    mkdir -pv \${GITSERVER_REPOS_ROOT} && \\
    chown -Rv \${DEBMIN_USERNAME}:developers \${GITSERVER_REPOS_ROOT} && \\
    chmod -v g+rxs \${GITSERVER_REPOS_ROOT} && \\
    echo /usr/bin/git-shell >> /etc/shells && \\
    chsh git -s /usr/bin/git-shell && \\
\\
# remove git source and build tools
  apt-get update && \\
  apt-get remove -y \\
    wget \\
    unzip \\
    build-essential \\
    libssl-dev \\
    libcurl4-openssl-dev \\
    libexpat1-dev \\
    gettext && \\
    apt-get update && \\
  apt-get autoremove -y && \\
  rm -Rf /root/Downloads
EOF

  if [[ -e ${__DOCKERFILE_PATH}_${TS} ]]; then

    fn__FileSameButForDate \
      ${__DOCKERFILE_PATH}  \
      ${__DOCKERFILE_PATH}_${TS} \
        && STS=${__THE_SAME} \
        || STS=${__DIFFERENT}

    if [[ ${STS} -eq ${__DIFFERENT} ]]; then
      __NEEDS_REBUILDING=${__YES}
    else
      rm -f ${__DOCKERFILE_PATH}_${TS}
    fi
  fi
  return ${__NEEDS_REBUILDING}

}


function fnUpdateOwnershipOfNonRootUserResources() {
  local lUsage='
      Usage: 
        fnUpdateOwnershipOfNonRootUserResources  \
          ${__GITSERVER_CONTAINER_NAME} \
          ${__GIT_USERNAME} \
          ${__GITSERVER_GUEST_HOME}  \
          ${__GITSERVER_SHELL}  \
          ${__GITSERVER_REPOS_ROOT}
      '
  [[ $# -lt  4 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }
  pContainerName=${1?"${lUsage}"}
  pGitUsername=${2?"${lUsage}"}
  pGuestHome=${3?"${lUsage}"}
  pContainerShell=${4?"${lUsage}"}
  pGitReposRoot=${5?"${lUsage}"}

  ${__DOCKER_EXE} container exec -itu root -w ${pGitReposRoot} ${pContainerName} ${pContainerShell} -lc "
  chown -R ${pGitUsername}:${pGitUsername} ${pGuestHome}
  chown -R ${pGitUsername}:${pGitUsername} ${pGitReposRoot}
  "
  echo "_____ Updated ownership of ${pGitUsername} resources on ${pContainerName}"
}


## functions
function fn__MakeCustomGitShellCommandsDirectory() {
  
    local -r lUsage='
  Usage: 
    fn__PopulateGitShellCommandsCustom \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
  [[ $# -lt 3 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }

  local -r pServerContainerName=${1?"${lUsage}"}
  local -r pGitUsername=${2?"${lUsage}"}
  local -r pShellInContainer=${3?"${lUsage}"}

  _CMD_="mkdir -p ${__GITSERVER_GUEST_HOME}/git-shell-commands"
  fn__ExecCommandInContainer \
    ${pServerContainerName} \
    ${pGitUsername} \
    ${pShellInContainer} \
    "${_CMD_}" \
      && STS=${__DONE} \
      || STS=${__FAILED}
  echo "______ Created Custom Git Shell Commands directory"; 
}


function fn__CreateCustomGitShellCommandsAndCopyToServer() {

  local -r lUsage='
  Usage: 
    fn__CreateCustomGitShellCommandsAndCopyToServer \
      ${__GITSERVER_CONTAINER_NAME} \
      ${__GIT_USERNAME} \
      ${__GITSERVER_SHELL} \
      ${__DEBMIN_HOME_DOS}  \
      ${__DEBMIN_HOME}  \
        && STS=${__DONE} \
        || STS=${__FAILED}
        '
  [[ $# -lt 5 || "${0^^}" == "HELP" ]] && {
    echo -e "______ Insufficient number of arguments $@\n${lUsage}"
    return ${__FAILED}
  }

  local -r pServerContainerName=${1?"${lUsage}"}
  local -r pGitUsername=${2?"${lUsage}"}
  local -r pShellInContainer=${3?"${lUsage}"}
  local -r pDebminHomeDosPath=${4?"${lUsage}"}
  local -r pDebminHome=${5?"${lUsage}"}

  # make and copy local files
  #
  mkdir -p ${pDebminHome}/git-shell-commands

  cat <<-'EOF' > ${pDebminHome}/git-shell-commands/menu.data
  The following commands are implemented

  -   help                    - show this help message
  -   list                    - list all git repositories
  -   backup <git repo name>  - backup the named repository

EOF
  fn__CopyFileFromHostToContainer \
    ${pServerContainerName} \
    "${pDebminHomeDosPath}\git-shell-commands\menu.data" \
    "${__GITSERVER_GUEST_HOME}/git-shell-commands/menu.data" \
      && STS=${__DONE} \
      || STS=${__FAILED}


  cat <<-EOF >${pDebminHome}/git-shell-commands/no-interactive-login 
#!/bin/sh
echo '----------------------------------------------------------------------'
printf '%s\n' "Hi ${USER}! You've successfully authenticated, but I do not"
printf '%s\n' "provide interactive shell access."
echo '----------------------------------------------------------------------'
echo "\$(IFS= cat ${__GITSERVER_GUEST_HOME}/git-shell-commands/menu.data | while read line; do echo "\${line}"; done)"
echo '----------------------------------------------------------------------'
#exit 128
EOF
  fn__CopyFileFromHostToContainer \
    ${pServerContainerName} \
    "${pDebminHomeDosPath}\git-shell-commands\no-interactive-login" \
    "${__GITSERVER_GUEST_HOME}/git-shell-commands/no-interactive-login" \
      && STS=${__DONE} \
      || STS=${__FAILED}


  cat <<-EOF > ${pDebminHome}/git-shell-commands/help
#!/bin/sh
echo "\$(IFS=  cat ${__GITSERVER_GUEST_HOME}/git-shell-commands/menu.data | while read line; do echo "\${line}"; done)"
exit 0
EOF
  fn__CopyFileFromHostToContainer \
    ${pServerContainerName} \
    "${pDebminHomeDosPath}\git-shell-commands\help" \
    "${__GITSERVER_GUEST_HOME}/git-shell-commands/help" \
      && STS=${__DONE} \
      || STS=${__FAILED}


  cat <<-EOF > ${pDebminHome}/git-shell-commands/list
#!/bin/sh
__GITSERVER_REPOS_ROOT="${__GITSERVER_REPOS_ROOT}"
echo
echo 'Repository Name'
echo '----------------------------------------------------------------------'
find ${__GITSERVER_REPOS_ROOT} -name \*.git -exec basename {} \; | while read i; do echo \${i%%.git}; done
echo '----------------------------------------------------------------------'
exit 0
EOF
  fn__CopyFileFromHostToContainer \
    ${pServerContainerName} \
    "${pDebminHomeDosPath}\git-shell-commands\list" \
    "${__GITSERVER_GUEST_HOME}/git-shell-commands/list" \
      && STS=${__DONE} \
      || STS=${__FAILED}


    cat <<-EOF > ${pDebminHome}/git-shell-commands/backup
#!/bin/sh
GITSERVER_REPOS_ROOT="${__GITSERVER_REPOS_ROOT}"
echo
repoName=\${1?"Name of the Git Repository, which to back, up is required"}
repoName=\${repoName%%.git}
[ -d \${GITSERVER_REPOS_ROOT}/\${repoName}.git ] \
  || { 
    echo "Repository \${1} does not exist - aborting"
    exit 1
  }
TS_FORMAT='+%Y-%m-%d_%H:%M:%S'
TS=\$(date \${TS_FORMAT})
cd \${GITSERVER_REPOS_ROOT}
tar czf \${HOME}/backups/\${repoName}_\${TS} \${repoName}.git || {
  STS=\$?
  echo "Failed to back up repository \${1}"
  echo "Please cpontact your git server administrator"
  exit \${STS}
}
echo "______ Backed up repository \${repoName} to file \${repoName}_\${TS}"
echo "______ \$(ls -lht --time-style="\${TS_FORMAT}" \${HOME}/backups/\${repoName}_\${TS} | cut -d' ' -f3- )"

exit 0
EOF
    fn__CopyFileFromHostToContainer \
      ${pServerContainerName} \
      "${pDebminHomeDosPath}\git-shell-commands\backup" \
      "${__GITSERVER_GUEST_HOME}/git-shell-commands/backup" \
        && STS=${__DONE} \
        || STS=${__FAILED}

  _CMD_="chown -Rv ${__GIT_USERNAME}:${__GIT_USERNAME} ${__GITSERVER_GUEST_HOME}"
  fn__ExecCommandInContainer \
    ${pServerContainerName} \
    "root" \
    ${pShellInContainer} \
    "${_CMD_}" \
      && STS=${__DONE} \
      || STS=${__FAILED}
  echo "______ Re-established ownership on ${__GIT_USERNAME} directory tree"; 


}


## ##################################################################################
## ##################################################################################
## 
## ##################################################################################
## ##################################################################################

# is there a command line argument that asks for the image to be uploaded ot the remote docker repository?

fn__PushToRemoteDockerRepo ${1} && STS=${__YES} || STS=${__NO} 
readonly __PUSH_TO_REMOTE_DOCKER_REPO=$STS

echo "______ Push of the image to the remote Docker repository has $([[ ${__PUSH_TO_REMOTE_DOCKER_REPO} -eq ${__NO} ]] && echo "NOT ")been requested."

# confirm working directory
#
__DEBMIN_HOME=$(pwd | sed 's|/_commonUtils||')

fn__ConfirmYN "Artefacts location will be ${__DEBMIN_HOME} - Is this correct?" && true || {
  echo "_____ Aborting ..."
  exit
}


fn__SetEnvironmentVariables ## && STS=${__SUCCESS} || STS=${__FAILED} # let it fail 
echo "_____ Set environment variables" 


fn__Create_docker_entry_point_file ${__GITSERVER_SHELL} ## && STS=${__SUCCESS} || STS=${__FAILED} # let it fail 
echo "_____ Created docker-entrypoint.sh" 


fn__CreateDockerfile && __REBUILD_IMAGE=${__YES} || __REBUILD_IMAGE=${__NO} # if dockerfile has not changed
echo "_____ Created Dockerfile: ${__DOCKERFILE_PATH}" 


fn__ImageExists \
  "${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}" &&
    __IMAGE_EXISTS=${__YES} || 
    __IMAGE_EXISTS=${__NO}
[[ ${__IMAGE_EXISTS} -eq ${__NO} ]]  \
  && {
    echo "_____ Image ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} does not exist"
    __REBUILD_IMAGE=${__YES}
  } \
  || echo "_____ Image ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} exists"


if [[ ${__REBUILD_IMAGE} -eq ${__YES} ]]; then
  fn__BuildImage  \
    ${__REBUILD_IMAGE} \
    ${__GITSERVER_IMAGE_NAME} \
    ${__GITSERVER_IMAGE_VERSION} \
    ${__DEBMIN_HOME_DOS}/Dockerfile.${__GITSERVER_IMAGE_NAME} \
    ${__DEVCICD_NET} ## && STS=${__SUCCESS} || STS=${__FAILED} # let it abort if failed
  echo "_____ Image ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} (re-)built"
fi


fn__ContainerExists \
  ${__GITSERVER_CONTAINER_NAME} \
    && STS=${__YES} \
    || STS=${__NO}

if [[ $STS -eq ${__YES} ]]; then
  echo "_____ Container ${__GITSERVER_CONTAINER_NAME} exists - will stopp and remove"
  fn__StopAndRemoveContainer  ${__GITSERVER_CONTAINER_NAME} && STS=${__YES} || STS=${__NO}
  echo "_____ Container ${__GITSERVER_CONTAINER_NAME} stopped and removed"
else
  echo "_____ Container ${__GITSERVER_CONTAINER_NAME} does not exist"
fi


fn__RunContainerDetached \
  ${__GITSERVER_IMAGE_NAME} \
  ${__GITSERVER_IMAGE_VERSION} \
  ${__GITSERVER_CONTAINER_NAME} \
  ${__GITSERVER_HOST_NAME} \
  ${__REMOVE_CONTAINER_ON_STOP} \
  ${__EMPTY} \
  ${__DEVCICD_NET} \
    && STS=${__DONE} || \
    STS=${__FAILED}
echo "_____ Container ${__GITSERVER_CONTAINER_NAME} started"


if [[ $STS -eq ${__DONE} ]]; then

  fnUpdateOwnershipOfNonRootUserResources  \
    ${__GITSERVER_CONTAINER_NAME} \
    ${__GIT_USERNAME} \
    ${__GITSERVER_GUEST_HOME}  \
    ${__GITSERVER_SHELL}  \
    ${__GITSERVER_REPOS_ROOT}
  echo "_____ Updated ownership of resources for user ${__GIT_USERNAME}"


  fn__MakeCustomGitShellCommandsDirectory \
    ${__GITSERVER_CONTAINER_NAME} \
    ${__GIT_USERNAME} \
    ${__GITSERVER_SHELL} \
      && {

        fn__CreateCustomGitShellCommandsAndCopyToServer \
          ${__GITSERVER_CONTAINER_NAME} \
          ${__GIT_USERNAME} \
          ${__GITSERVER_SHELL} \
          ${__DEBMIN_HOME_DOS}  \
          ${__DEBMIN_HOME}  \
            && {
              echo "______ Created Custom Git Shell Commands"; 
            } \
            || STS=${__FAILED}
      } \
      || STS=${__FAILED}


  fn__CommitChangesStopContainerAndSaveImage   \
    "${__GITSERVER_CONTAINER_NAME}" \
    "${__GITSERVER_IMAGE_NAME}" \
    "${__GITSERVER_IMAGE_VERSION}"
  echo "_____ Commited changes to ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} and Stopped container ${__CONTAINER_NAME}"


  if [[ ${__PUSH_TO_REMOTE_DOCKER_REPO} == ${__YES} ]]; then

    fn__PushImageToRemoteRepository   \
      "${__DOCKER_REPOSITORY_HOST}"  \
      "${__GITSERVER_IMAGE_NAME}" \
      "${__GITSERVER_IMAGE_VERSION}"
    echo "_____ Image tagged and pushed to repository as ${__DOCKER_REPOSITORY_HOST}/${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION}" 
  else
    echo "_____ On user request on user request image ${__GITSERVER_IMAGE_NAME}:${__GITSERVER_IMAGE_VERSION} has NOT been pushed to Docker repository ${__DOCKER_REPOSITORY_HOST}" 
  fi


else
  ${__INDUCE_ERROR}
fi

echo "Done..."
