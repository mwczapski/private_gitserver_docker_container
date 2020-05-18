
# #############################################
# The MIT License (MIT)
#
# Copyright © 2020 Michael Czapski
# #############################################

declare -u __env_GlobalConstants="SOURCED"

readonly __ZERO__=0
readonly __TRUE=${__ZERO__}
readonly __YES=${__ZERO__}
readonly __SUCCESS=${__ZERO__}
readonly __DONE=${__ZERO__}
readonly __THE_SAME=${__ZERO__}

readonly __ONE__=1
readonly __FALSE=${__ONE__}
readonly __NO=${__ONE__}
readonly __FAILED=${__ONE__}
readonly __DIFFERENT=${__ONE__}

readonly __EXECUTION_ERROR=11

readonly __IGNORE_ERROR=true
readonly __INDUCE_ERROR=false

readonly __EMPTY="EMPTY"

readonly __SCRIPTS_DIRECTORY_NAME='_commonUtils'
readonly __DEBMIN_SOURCE_IMAGE_NAME='bitnami/minideb:jessie'

readonly __MAX_CONTAIMER_NAME_LENGTH=40
readonly __IDENTIFIER_MAX_LEN=40

readonly __TZ_PATH="Australia/Sydney"
readonly __TZ_NAME="Australia/Sydney"

readonly __INSUFFICIENT_ARGS="______ Insufficient number of arguments"
readonly __INSUFFICIENT_ARGS_STS=200
readonly __EMPTY_ARGUMENT_NOT_ALLOWED=201
readonly __NO_SUCH_DIRECTORY=203
readonly __INVALID_VALUE=204
