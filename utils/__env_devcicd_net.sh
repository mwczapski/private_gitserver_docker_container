

# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u __env_devcicd_net="SOURCED"

[[ ${__env_GlobalConstants} ]] || source ./utils/__env_GlobalConstants.sh

# change this if you want to create network with a different name
#
readonly __DEVCICD_NET_DC_INTERNAL="devcicd_net"

# chage this to have the created network use a different subnet
# if the network already exists __DEVCICD_SUBNET_ADDRESS will be replaced
# with existing subnet spec
#
__DEVCICD_SUBNET_ADDRESS="172.30.0.0/16"

readonly __DEVCICD_NET="docker_${__DEVCICD_NET_DC_INTERNAL}"  ## docker-compose prefixes network names with docker_
__DEVCICD_NET_PREFIX=${__DEVCICD_SUBNET_ADDRESS%%.0/16}
__DEVCICD_SUBNET_GATEWAY=${__DEVCICD_NET_PREFIX}.1


[[ ${__DOCKER_COMPOSE_NO_EXT:-NO} == "NO" ]] \
  && {
    echo "fn__DockerGeneric.sh is a pre-requisite for ${0} - sourcing it"
    source ./utils/fn__DockerGeneric.sh
  } \
  || true

fn__DockerNetworkExists \
  ${__DEVCICD_NET} \
  && echo "______ Network '${__DEVCICD_NET}' exists. Will use it." \
  ||                              \
    fn__CreateDockerNetwork       \
      ${__DEVCICD_NET}            \
      ${__DEVCICD_SUBNET_ADDRESS} \
      ${__DEVCICD_SUBNET_GATEWAY} \
        || {
          echo "______ Failed to create network ${__DEVCICD_NET}. Script cannot continue."
          exit
        }

# determine and set/reset derived network variables
#
__DEVCICD_SUBNET_ADDRESS="$(${__DOCKER_EXE} network inspect ${__DEVCICD_NET} | grep 'Subnet' | sed 's|"Subnet": "||;s|",$||')"
__DEVCICD_NET_PREFIX=$(${__DOCKER_EXE} network inspect ${__DEVCICD_NET} | grep 'Gateway' | sed 's/^.*: .//;s/.[0-9].1$//;s|.1"||' )
__DEVCICD_SUBNET_GATEWAY=${__DEVCICD_NET_PREFIX}.1

GITSERVER_STATIC_SERVER_IP=${__DEVCICD_NET_PREFIX}.250


######################################################################################
### need to work out how to deal with network address before netwrk is created - use static subnet set someplace and used elsewhere
######################################################################################
