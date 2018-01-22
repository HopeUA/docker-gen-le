#!/bin/bash
set -e

DIR="$(dirname "$0")"
. $DIR/functions.sh

start_tests

### Test 1
# Check Docker gen version
###
run_test
echo -n "Docker Gen version: "
docker-gen -version

### Test 2
# Check SimpLE version
###
run_test
echo -n "LE client version: "
simp_le --version
simp_le --test

tests_passed
