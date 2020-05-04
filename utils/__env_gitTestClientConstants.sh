
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u __env_gitTestClientConstants="SOURCED"

[[ ${__env_devcicd_net} ]] || source __env_devcicd_net.sh
[[ ${__env_gitserverConstants} ]] || source ./utils/__env_gitserverConstants.sh

readonly __GIT_TEST_CLIENT_USERNAME="gittest"
readonly __GIT_TEST_CLIENT_NAME="gittestclient"
readonly __GIT_TEST_CLIENT_SHELL="/bin/bash"
readonly __GIT_TEST_CLIENT_SHELL_GLOBAL_PROFILE="/etc/profile"
readonly __GIT_TEST_CLIENT_SHELL_PROFILE=".bash_profile"
readonly __GIT_TEST_CLIENT_IMAGE_NAME="gittestclient"
readonly __GIT_TEST_CLIENT_IMAGE_VERSION="1.0.0"
readonly __GIT_TEST_CLIENT_HOST_NAME="gittestclient"
readonly __GIT_TEST_CLIENT_CONTAINER_NAME="gittestclient"
readonly __GIT_TEST_CLIENT_GUEST_HOME="/home/${__GIT_TEST_CLIENT_USERNAME}"
