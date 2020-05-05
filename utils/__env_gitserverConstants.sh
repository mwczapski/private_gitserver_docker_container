
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u __env_gitserverConstants="SOURCED"

[[ ${__env_devcicd_net} ]] || source ./utils/__env_devcicd_net.sh

# [[ ${GITSERVER_STATIC_SERVER_IP:-NO} == "NO" ]] \
#   && {
#     echo "__env_devcicd_net.sh is a pre-requisite for ${0} - sourcing it"
#     source ./utils/__env_devcicd_net.sh
#   } || true

readonly __GIT_HOST_PORT=50022
readonly _GIT_GUEST_PORT_=22

readonly __GIT_USERNAME="git"
readonly __GITSERVER_USERNAME="gitserver"
readonly __GITSERVER_NAME="gitserver"
readonly __GITSERVER_SHELL="/bin/bash"
readonly __GITSERVER_SHELL_GLOBAL_PROFILE="/etc/profile"
readonly __GITSERVER_SHELL_PROFILE=".bash_profile"
readonly __GITSERVER_IMAGE_NAME="gitserver"
readonly __GITSERVER_IMAGE_VERSION="1.0.0"
readonly __GITSERVER_HOST_NAME="gitserver"
readonly __GITSERVER_CONTAINER_NAME="gitserver"
readonly __GITSERVER_MAPPED_PORTS="--publish=127.0.0.1:${__GIT_HOST_PORT}:${_GIT_GUEST_PORT_}/tcp"
         __GITSERVER_PORT_MAPPINGS[0]="127.0.0.1:${__GIT_HOST_PORT}:${_GIT_GUEST_PORT_}/tcp"  # can't be readonly - gives exception
readonly __GITSERVER_ADDHOST="--add-host=${__GITSERVER_NAME}:${GITSERVER_STATIC_SERVER_IP}"
readonly __GITSERVER_REPOS_ROOT="/opt/gitrepos"
readonly __GITSERVER_GUEST_HOME="/home/${__GIT_USERNAME}"
readonly __GITSERVER_HOST_BACKUP_DIR="${__GITSERVER_GUEST_HOME}/backups"
readonly __GITSERVER_REM_TEST_REPO_NAME="gittest"
