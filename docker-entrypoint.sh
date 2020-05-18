#!/bin/bash 

set -e
set -u

service ssh start

# prevent container from exiting after successfull startup
exec /bin/bash -c 'while true; do sleep 100000; done'
