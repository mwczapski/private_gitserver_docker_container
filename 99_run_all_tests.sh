#!/bin/bash

#  find . -name \*_tests.sh -exec /bin/bash -c "_FORCE_RUNNING_ALL_TESTS_='A' {}" \;
cat <<-'EOF' > ./99_run_all_tests_do.sh
#!/bin/bash
#   find . -name \*_tests.sh -exec echo "_FORCE_RUNNING_ALL_TESTS_='YES' {}" \; >> ./99_run_all_tests_do.sh

EOF
find . -name \*_tests.sh -exec echo "_FORCE_RUNNING_ALL_TESTS_='YES' {}" \; | grep -v ${0} >> ./99_run_all_tests_do.sh

chmod u+x ./99_run_all_tests_do.sh

./99_run_all_tests_do.sh
