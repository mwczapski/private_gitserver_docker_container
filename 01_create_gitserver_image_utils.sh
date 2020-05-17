#!/bin/bash

###############################################
## The MIT License (MIT)
##
## Copyright © 2020 Michael Czapski
###############################################

declare -ur _01_create_gitserver_image_utils="SOURCED"

# common environment variable values and utility functions
#
[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh
# [[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh
# [[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh
[[ ${fn__UtilityGeneric} ]] || source ./utils/fn__UtilityGeneric.sh
# [[ ${fn__DockerGeneric} ]] || source ./utils/fn__DockerGeneric.sh
[[ ${fn__WSLPathToDOSandWSDPaths} ]] || source ./utils/fn__WSLPathToDOSandWSDPaths.sh

# [[ ${fn__CreateWindowsShortcut} ]] || source ./utils/fn__CreateWindowsShortcut.sh





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
function fn__SetEnvironmentVariables() {
  local -r lUsage='
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
    '
  # this picks up missing arguments
  #
  [[ $# -lt 13 || "${0^^}" == "HELP" ]] && {
    echo -e "${__INSUFFICIENT_ARGS}\n${lUsage}"
    return ${__FAILED}
  }

  test -z ${1} 2>/dev/null && { echo "1st Argument value, '${1}', is invalid"; return ${__FAILED} ; }
  test -z ${2} 2>/dev/null && { echo "2nd Argument value, '${2}', is invalid"; return ${__FAILED} ; }
  test -z ${3} 2>/dev/null && { echo "3rd Argument value, '${3}', is invalid"; return ${__FAILED} ; }

  fn__RefVariableExists ${5} || { echo "4th Argument value, '${4}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${5} || { echo "5th Argument value, '${5}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${6} || { echo "6th Argument value, '${6}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${7} || { echo "7th Argument value, '${7}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${8} || { echo "8th Argument value, '${8}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${9} || { echo "9th Argument value, '${9}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${10} || { echo "10th Argument value, '${10}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${11} || { echo "11th Argument value, '${11}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${12} || { echo "12th Argument value, '${12}', is invalid"; return ${__FAILED} ; }
  fn__RefVariableExists ${13} || { echo "13th Argument value, '${13}', is invalid"; return ${__FAILED} ; }

  # name reference variables
  #
  local rScriptsDirectoryName=${1}
  local rGitserverImageName=${2}
  local rGitserverShellGlobalProfile=${3}
  local -n rDebminHome=${4}
  local -n rDebminHomeDOS=${5}
  local -n rDebminHomeWSD=${6}
  local -n rDebminSourceImageName=${7}
  local -n rTZPath=${8} 
  local -n rTZName=${9}
  local -n rGlobalShellProfile=${10}
  local -n rDockerfilePath=${11}
  local -n rRemoveContainerOnStop=${12}
  local -n rNeedsRebuilding=${13}

  test ${#rScriptsDirectoryName} -lt 1 &&  { echo "1st Argument, '${1}', must have a valid value"; return ${__FAILED} ; }
  test ${#rGitserverImageName} -lt 1 &&  { echo "2nd Argument, '${2}', must have a valid value"; return ${__FAILED} ; }
  test ${#rGitserverShellGlobalProfile} -lt 1 &&  { echo "3rd Argument, '${3}', must have a valid value"; return ${__FAILED} ; }
  test ${#rDebminHome} -lt 1 &&  { echo "4th Argument, '${4}', must have a valid value"; return ${__FAILED} ; }

  # derived values
  #
  rDebminHome=${rDebminHome%%/${rScriptsDirectoryName}} # strip _commonUtils

  cd ${rDebminHome} 2>/dev/null && STS=$? || STS=$?
  [[ ${STS} -ne ${__SUCCESS} ]] && { echo "cd: ${rDebminHome}: No such file or directory"; return ${__FAILED}; }

  rDebminHomeDOS=$(fn__WSLPathToRealDosPath ${rDebminHome})
  rDebminHomeWSD=$(fn__WSLPathToWSDPath ${rDebminHome})
  rDebminSourceImageName="bitnami/minideb:jessie"
  rTZPath="Australia/Sydney"
  rTZName="Australia/Sydney"
  rGlobalShellProfile="${rGitserverShellGlobalProfile}"
  rDockerfilePath=${rDebminHome}/Dockerfile.${rGitserverImageName}

  ## options toggles 
  rRemoveContainerOnStop=${__YES} # container started using this image is nto supposed to be used for work
  rNeedsRebuilding=${__NO}  # set to ${__YES} if image does not exist of Dockerfile changed

  # echo "rDebminHome: |${rDebminHome}|"
  # echo "rDebminHomeDOS: |${rDebminHomeDOS}|"
  # echo "rDebminHomeWSD: |${rDebminHomeWSD}|"
  # echo "rDebminSourceImageName: |${rDebminSourceImageName}|"
  # echo "rTZPath: |${rTZPath}|"
  # echo "rTZName: |${rTZName}|"
  # echo "rGlobalShellProfile: |${rGlobalShellProfile}|"
  # echo "rDockerfilePath: |${rDockerfilePath}|"
  # echo "rRemoveContainerOnStop: |${rRemoveContainerOnStop}|"
  # echo "rNeedsRebuilding: |${rNeedsRebuilding}|"

  return ${__SUCCESS}

}


# function fn__Create_docker_entry_point_file() {

#     local lUsage='
# Usage: 
#     fn__Create_docker_entry_point_file \
#       ${__GITSERVER_SHELL}
# '
#   [[ $# -lt  1 || "${0^^}" == "HELP" ]] && {
#     echo -e "______ Insufficient number of arguments $@\n${lUsage}"
#     return ${__FAILED}
#   }
 
#   local pGuestShell=${1?"Full path to guest's shell binary, for example /bin/bash or /bin/ash or /bin/sh"}

#   cat <<-EOF > ${__DEBMIN_HOME}/docker-entrypoint.sh
# #!/bin/bash
# set -e
# 
# service ssh start
# 
# # prevent container from exiting after successfull startup
# exec /bin/bash -c 'while true; do sleep 100000; done'
# EOF
#   chmod +x ${__DEBMIN_HOME}/docker-entrypoint.sh
# }


# function fn__CreateDockerfile() {

#   # create Dockerfile
#   local __NEEDS_REBUILDING=${__NO}
#   local STS=${__SUCCESS}

#   local TS=$(date '+%Y%m%d_%H%M%S')
#   [[ -e ${__DOCKERFILE_PATH} ]] && cp ${__DOCKERFILE_PATH} ${__DOCKERFILE_PATH}_${TS}
    
#   cat <<-EOF > ${__DOCKERFILE_PATH}
# FROM ${__DEBMIN_SOURCE_IMAGE_NAME}

# ## Dockerfile Version: ${TS}
# ##
# # the environment variables below will be used in creating the image
# # and will be available to the containers created from the image ...
# #
# 
# ENV DEBMIN_USERNAME=${__GIT_USERNAME} \\
#     DEBMIN_SHELL=${__GITSERVER_SHELL} \\
#     DEBMIN_SHELL_PROFILE=${__GITSERVER_SHELL_PROFILE} \\
#     GITSERVER_REPOS_ROOT=${__GITSERVER_REPOS_ROOT} \\
#     TZ_PATH=${__TZ_PATH} \\
#     TZ_NAME=${__TZ_NAME}  \\
#     ENV=${__ENV}  \\
#     DEBIAN_FRONTEND=noninteractive

# COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# # install necessary / usefull extra packages
# # the following are needed to download, builld and install git from sources
# # wget, unzip, build-essential, libssl-dev, libcurl4-openssl-dev, libexpat1-dev, gettex
# #
# RUN export DEBIAN_FRONTEND=noninteractive && \\
#   apt-get update && \\
#   apt-get upgrade -y && \\
#   apt-get -y install apt-utils && \\
#   apt-get -y install \\
#     tzdata \\
#     net-tools \\
#     iputils-ping \\
#     openssh-client \\
#     openssh-server \\
#     less \\
#     nano \\
# # the following are needed to download, builld and install git from sources
#     wget \\
#     unzip \\
#     build-essential \\
#     libssl-dev \\
#     libcurl4-openssl-dev \\
#     libexpat1-dev \\
#     gettext && \\
# \\
# # set timezone - I live in Sydney - change as you see fit in the env variables above
#     cp -v /usr/share/zoneinfo/\${TZ_PATH} /etc/localtime && \\
#     echo "\${TZ_NAME}" > /etc/timezone && \\
#     echo \$(date) && \\
# \\
# # create git user
#     addgroup developers && \\
#     useradd -G developers -m \${DEBMIN_USERNAME} -s \${DEBMIN_SHELL} -p \${DEBMIN_USERNAME} && \\
# \\
# ## configure git and ssh access to git repositories on this git server
#     sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config && \\
# \\
# # download and install latest git
#     mkdir -pv /root/Downloads/git-master && \\
#     cd /root/Downloads && \\
#     wget https://github.com/git/git/archive/master.zip -O /root/Downloads/git-master-${TS}.zip  && \\
#     unzip /root/Downloads/git-master-${TS}.zip && \\
#     cd /root/Downloads/git-master && \\
#     make prefix=/usr all  && \\
#     make prefix=/usr install  && \\
#     git --version && \\
# \\
# # create user's .ssh directory
#     mkdir -pv /home/\${DEBMIN_USERNAME}/.ssh/ && \\
#     touch /home/\${DEBMIN_USERNAME}/.ssh/authorized_keys && \\
#     chmod 600 /home/\${DEBMIN_USERNAME}/.ssh/authorized_keys && \\
#     mkdir -pv \${GITSERVER_REPOS_ROOT} && \\
#     chown -Rv \${DEBMIN_USERNAME}:developers \${GITSERVER_REPOS_ROOT} && \\
#     chmod -v g+rxs \${GITSERVER_REPOS_ROOT} && \\
#     echo /usr/bin/git-shell >> /etc/shells && \\
#     chsh git -s /usr/bin/git-shell && \\
# \\
# # remove git source and build tools
#   apt-get update && \\
#   apt-get remove -y \\
#     wget \\
#     unzip \\
#     build-essential \\
#     libssl-dev \\
#     libcurl4-openssl-dev \\
#     libexpat1-dev \\
#     gettext && \\
#     apt-get update && \\
#   apt-get autoremove -y && \\
#   rm -Rf /root/Downloads
# EOF

#   if [[ -e ${__DOCKERFILE_PATH}_${TS} ]]; then

#     fn__FileSameButForDate \
#       ${__DOCKERFILE_PATH}  \
#       ${__DOCKERFILE_PATH}_${TS} \
#         && STS=${__THE_SAME} \
#         || STS=${__DIFFERENT}

#     if [[ ${STS} -eq ${__DIFFERENT} ]]; then
#       __NEEDS_REBUILDING=${__YES}
#     else
#       rm -f ${__DOCKERFILE_PATH}_${TS}
#     fi
#   fi
#   return ${__NEEDS_REBUILDING}

# }


# function fnUpdateOwnershipOfNonRootUserResources() {
#   local lUsage='
#       Usage: 
#         fnUpdateOwnershipOfNonRootUserResources  \
#           ${__GITSERVER_CONTAINER_NAME} \
#           ${__GIT_USERNAME} \
#           ${__GITSERVER_GUEST_HOME}  \
#           ${__GITSERVER_SHELL}  \
#           ${__GITSERVER_REPOS_ROOT}
#       '
#   [[ $# -lt  4 || "${0^^}" == "HELP" ]] && {
#     echo -e "______ Insufficient number of arguments $@\n${lUsage}"
#     return ${__FAILED}
#   }
#   pContainerName=${1?"${lUsage}"}
#   pGitUsername=${2?"${lUsage}"}
#   pGuestHome=${3?"${lUsage}"}
#   pContainerShell=${4?"${lUsage}"}
#   pGitReposRoot=${5?"${lUsage}"}

#   ${__DOCKER_EXE} container exec -itu root -w ${pGitReposRoot} ${pContainerName} ${pContainerShell} -lc "
#   chown -R ${pGitUsername}:${pGitUsername} ${pGuestHome}
#   chown -R ${pGitUsername}:${pGitUsername} ${pGitReposRoot}
#   "
#   echo "_____ Updated ownership of ${pGitUsername} resources on ${pContainerName}"
# }


# ## functions
# function fn__MakeCustomGitShellCommandsDirectory() {
  
#     local -r lUsage='
#   Usage: 
#     fn__PopulateGitShellCommandsCustom \
#       ${__GITSERVER_CONTAINER_NAME} \
#       ${__GIT_USERNAME} \
#       ${__GITSERVER_SHELL} \
#         && STS=${__DONE} \
#         || STS=${__FAILED}
#         '
#   [[ $# -lt 3 || "${0^^}" == "HELP" ]] && {
#     echo -e "______ Insufficient number of arguments $@\n${lUsage}"
#     return ${__FAILED}
#   }

#   local -r pServerContainerName=${1?"${lUsage}"}
#   local -r pGitUsername=${2?"${lUsage}"}
#   local -r pShellInContainer=${3?"${lUsage}"}

#   _CMD_="mkdir -p ${__GITSERVER_GUEST_HOME}/git-shell-commands"
#   fn__ExecCommandInContainer \
#     ${pServerContainerName} \
#     ${pGitUsername} \
#     ${pShellInContainer} \
#     "${_CMD_}" \
#       && STS=${__DONE} \
#       || STS=${__FAILED}
#   echo "______ Created Custom Git Shell Commands directory"; 
# }


# function fn__CreateCustomGitShellCommandsAndCopyToServer() {

#   local -r lUsage='
#   Usage: 
#     fn__CreateCustomGitShellCommandsAndCopyToServer \
#       ${__GITSERVER_CONTAINER_NAME} \
#       ${__GIT_USERNAME} \
#       ${__GITSERVER_SHELL} \
#       ${__DEBMIN_HOME_DOS}  \
#       ${__DEBMIN_HOME}  \
#         && STS=${__DONE} \
#         || STS=${__FAILED}
#         '
#   [[ $# -lt 5 || "${0^^}" == "HELP" ]] && {
#     echo -e "______ Insufficient number of arguments $@\n${lUsage}"
#     return ${__FAILED}
#   }

#   local -r pServerContainerName=${1?"${lUsage}"}
#   local -r pGitUsername=${2?"${lUsage}"}
#   local -r pShellInContainer=${3?"${lUsage}"}
#   local -r pDebminHomeDosPath=${4?"${lUsage}"}
#   local -r pDebminHome=${5?"${lUsage}"}

#   # make and copy local files
#   #
#   mkdir -p ${pDebminHome}/git-shell-commands

#   cat <<-'EOF' > ${pDebminHome}/git-shell-commands/menu.data
#   The following commands are implemented

#   -   help                    - show this help message
#   -   list                    - list all git repositories
#   -   backup <git repo name>  - backup the named repository

# EOF
#   fn__CopyFileFromHostToContainer \
#     ${pServerContainerName} \
#     "${pDebminHomeDosPath}\git-shell-commands\menu.data" \
#     "${__GITSERVER_GUEST_HOME}/git-shell-commands/menu.data" \
#       && STS=${__DONE} \
#       || STS=${__FAILED}


#   cat <<-EOF >${pDebminHome}/git-shell-commands/no-interactive-login 
# #!/bin/sh
# echo '----------------------------------------------------------------------'
# printf '%s\n' "Hi ${USER}! You've successfully authenticated, but I do not"
# printf '%s\n' "provide interactive shell access."
# echo '----------------------------------------------------------------------'
# echo "\$(IFS= cat ${__GITSERVER_GUEST_HOME}/git-shell-commands/menu.data | while read line; do echo "\${line}"; done)"
# echo '----------------------------------------------------------------------'
# #exit 128
# EOF
#   fn__CopyFileFromHostToContainer \
#     ${pServerContainerName} \
#     "${pDebminHomeDosPath}\git-shell-commands\no-interactive-login" \
#     "${__GITSERVER_GUEST_HOME}/git-shell-commands/no-interactive-login" \
#       && STS=${__DONE} \
#       || STS=${__FAILED}


#   cat <<-EOF > ${pDebminHome}/git-shell-commands/help
# #!/bin/sh
# echo "\$(IFS=  cat ${__GITSERVER_GUEST_HOME}/git-shell-commands/menu.data | while read line; do echo "\${line}"; done)"
# exit 0
# EOF
#   fn__CopyFileFromHostToContainer \
#     ${pServerContainerName} \
#     "${pDebminHomeDosPath}\git-shell-commands\help" \
#     "${__GITSERVER_GUEST_HOME}/git-shell-commands/help" \
#       && STS=${__DONE} \
#       || STS=${__FAILED}


#   cat <<-EOF > ${pDebminHome}/git-shell-commands/list
# #!/bin/sh
# __GITSERVER_REPOS_ROOT="${__GITSERVER_REPOS_ROOT}"
# echo
# echo 'Repository Name'
# echo '----------------------------------------------------------------------'
# find ${__GITSERVER_REPOS_ROOT} -name \*.git -exec basename {} \; | while read i; do echo \${i%%.git}; done
# echo '----------------------------------------------------------------------'
# exit 0
# EOF
#   fn__CopyFileFromHostToContainer \
#     ${pServerContainerName} \
#     "${pDebminHomeDosPath}\git-shell-commands\list" \
#     "${__GITSERVER_GUEST_HOME}/git-shell-commands/list" \
#       && STS=${__DONE} \
#       || STS=${__FAILED}


#     cat <<-EOF > ${pDebminHome}/git-shell-commands/backup
# #!/bin/sh
# GITSERVER_REPOS_ROOT="${__GITSERVER_REPOS_ROOT}"
# echo
# repoName=\${1?"Name of the Git Repository, which to back, up is required"}
# repoName=\${repoName%%.git}
# [ -d \${GITSERVER_REPOS_ROOT}/\${repoName}.git ] \
#   || { 
#     echo "Repository \${1} does not exist - aborting"
#     exit 1
#   }
# TS_FORMAT='+%Y-%m-%d_%H:%M:%S'
# TS=\$(date \${TS_FORMAT})
# cd \${GITSERVER_REPOS_ROOT}
# tar czf \${HOME}/backups/\${repoName}_\${TS} \${repoName}.git || {
#   STS=\$?
#   echo "Failed to back up repository \${1}"
#   echo "Please cpontact your git server administrator"
#   exit \${STS}
# }
# echo "______ Backed up repository \${repoName} to file \${repoName}_\${TS}"
# echo "______ \$(ls -lht --time-style="\${TS_FORMAT}" \${HOME}/backups/\${repoName}_\${TS} | cut -d' ' -f3- )"

# exit 0
# EOF
#     fn__CopyFileFromHostToContainer \
#       ${pServerContainerName} \
#       "${pDebminHomeDosPath}\git-shell-commands\backup" \
#       "${__GITSERVER_GUEST_HOME}/git-shell-commands/backup" \
#         && STS=${__DONE} \
#         || STS=${__FAILED}

#   _CMD_="chown -Rv ${__GIT_USERNAME}:${__GIT_USERNAME} ${__GITSERVER_GUEST_HOME}"
#   fn__ExecCommandInContainer \
#     ${pServerContainerName} \
#     "root" \
#     ${pShellInContainer} \
#     "${_CMD_}" \
#       && STS=${__DONE} \
#       || STS=${__FAILED}
#   echo "______ Re-established ownership on ${__GIT_USERNAME} directory tree"; 


# }
