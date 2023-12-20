#!/bin/bash
#
# A convenient script to run level 2 unit test (eg. integration test)
#
set -xue -o pipefail

##############################
# 0. start from scratch
##############################
rm -rf build/ install/
set +u                          # stop checking undefined variable  
source /opt/ros/humble/setup.bash
set -u                          # re-enable undefined variable check

##############################
# 1. Build for test coverage
##############################
colcon build --cmake-args -DCOVERAGE=1
set +u                          # stop checking undefined variable  
source install/setup.bash
set -u                          # re-enable undefined variable check

##############################
# 2. run all tests
##############################
colcon test

##############################
# 3. get return status  (none-zero will cause the script to exit)
##############################
colcon test-result --test-result-base build/seeker_swarm

##############################
# 4. generate individual coverage reports:
##############################
## 4.1 my_model:
# colcon build \
#        --event-handlers console_cohesion+ \
#        --packages-select seeker_swarm \
#        --cmake-target "test_coverage" \
#        --cmake-arg -DUNIT_TEST_ALREADY_RAN=1
# MY_MODEL_COVERAGE_INFO=./build/seeker_swarm/test_coverage.info
## 4.2 my_controller:
ros2 run seeker_swarm generate_coverage_report.bash
MY_CONTROLLER_COVERAGE_INFO=./build/seeker_swarm/test_coverage.info
MY_SEEKER_SWARM_COVERAGE_INFO = ./build/seeker_swarm//test_coverage
open $MY_SEEKER_SWARM_COVERAGE_INFO/index.html || true


# lcov -a $MY_MODEL_COVERAGE_INFO -a \
#      $MY_CONTROLLER_COVERAGE_INFO -o \
#      $ALL_COVERAGE_INFO


##############################
# 5. Combine coverage reports
##############################
## create output directory
# COMBINED_TEST_COVERAGE=combined_test_coverage
# if [[ -d $COMBINED_TEST_COVERAGE ]]; then
#    rm -rf $COMBINED_TEST_COVERAGE
# fi
# mkdir $COMBINED_TEST_COVERAGE
# ## combine the reports
# ALL_COVERAGE_INFO=./build/test_coverage_merged.info
# lcov -a $MY_MODEL_COVERAGE_INFO -a \
#      $MY_CONTROLLER_COVERAGE_INFO -o \
#      $ALL_COVERAGE_INFO

# genhtml --output-dir $COMBINED_TEST_COVERAGE $ALL_COVERAGE_INFO

# ##############################
# # 6. show the combined coverage report
# ##############################
# open $COMBINED_TEST_COVERAGE/index.html || true
