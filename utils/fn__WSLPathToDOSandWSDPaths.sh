# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u fn__WSLPathToDOSandWSDPaths="SOURCED"

function fn__WSLPathToRealDosPath() { 
  echo $1 | sed 's|/mnt/\(.\)|\1:|;s|/|\\|g'; 
}

# function fn__WSLPathToDOSandWSDPaths() { 
#   echo $1 | sed 's|/mnt/\(.\)|\1:|' | tr '/' '\\'; 
# }

function fn__WSLPathToWSDPath() { 
  echo $1 | sed 's|/mnt/\(.\)|\1:|'; 
}