#!/bin/bash

MODULE=${1:-""}
BROWSER=${2:-"chromium"}
REPORTER=${3:-"github"}
ATTEMPTS=${4:-3}
TEST_SUCCESS=0

# makes it easier to see script alerts in firehose
function wrap-ansi() {
    local ANSI_CODE="$1"
    local STR="$2"

    echo -e "\n\033[${ANSI_CODE}m $STR \033[0m\n"
}

# reduce repitition for alerting on attempt status
function attempt-status-alert() {
    local ANSI_CODE="$1"
    local ATTEMPT="$2"
    local MODULE="$3"
    local STR="$4"

    if [ -z "$MODULE" ]; then
        wrap-ansi "$ANSI_CODE" "Attempt $ATTEMPT: $STR"
    else
        wrap-ansi "$ANSI_CODE" "Attempt $ATTEMPT for $MODULE: $STR"
    fi
}

if [ -z "$MODULE" ]; then
    wrap-ansi 42 "Attempting tests at most $ATTEMPTS times using $BROWSER browser and $REPORTER reporter"
else
    wrap-ansi 42 "Running $MODULE tests at most $ATTEMPTS times using $BROWSER browser and $REPORTER reporter"
fi

# attempts test ATTEMPTS times, running cleanup between test attempts
for ((i = 1; i <= $ATTEMPTS; i++)); do
    npm run test --module=$MODULE --platform=$BROWSER --reporter=$REPORTER

    # if test returned 0 - success!
    if [ $? -eq 0 ]; then
        echo "$(attempt-status-alert 42 $i $MODULE "tests succeeded")"
        TEST_SUCCESS=1
        break
    # else - test failed
    else
        # if last attempt - give up
        if [ $i -eq $ATTEMPTS ]; then
            attempt-status-alert 41 $i $MODULE "tests failed"
        # else - run cleanup, trying again
        else
            attempt-status-alert 43 $i $MODULE "tests failed - running cleanup and trying again ..."
            npm run cleanup
        fi
    fi
done

# if tests never succeeded - exit with error
if [ $TEST_SUCCESS -eq 0 ]; then
    exit 1
fi
