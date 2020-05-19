#!/bin/bash
#   find . -name \*_tests.sh -exec echo "_FORCE_RUNNING_ALL_TESTS_='YES' {}" \; >> ./99_run_all_tests_do.sh

_FORCE_RUNNING_ALL_TESTS_='YES' ./01_create_gitserver_image_utils_tests.sh
_FORCE_RUNNING_ALL_TESTS_='YES' ./02_create_gitserver_container_utils_tests.sh
_FORCE_RUNNING_ALL_TESTS_='YES' ./utils/fn__GitserverGeneric_tests.sh
_FORCE_RUNNING_ALL_TESTS_='YES' ./utils/fn__SSHInContainerUtils_tests.sh
_FORCE_RUNNING_ALL_TESTS_='YES' ./utils/fn__UtilityGeneric_tests.sh
_FORCE_RUNNING_ALL_TESTS_='YES' ./utils/fn__WSLPathToDOSandWSDPaths_tests.sh
