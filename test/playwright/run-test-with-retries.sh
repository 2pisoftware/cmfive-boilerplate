#!/bin/bash

MODULE=${1:-""}
BROWSER=${2:-"chromium"}
REPORTER=${3:-"github"}
ATTEMPTS=${4:-3}

function attempt-status-alert() {
    local ANSI_CODE="$1"
    local ATTEMPT="$2"
    local MODULE="$3"
    local STR="$4"

    # if length of MODULE string is 0, say something else
    if [ -z "$MODULE" ]; then
        echo -e "\n\033[${ANSI_CODE}m Attempt $ATTEMPT: $STR \033[0m\n"
    else
        echo -e "\n\033[${ANSI_CODE}m Attempt $ATTEMPT for $MODULE: $STR \033[0m\n"
    fi
}

for ((i = 1; i <= $ATTEMPTS; i++)); do
    npm run test --module=$MODULE --platform=$BROWSER --reporter=$REPORTER

    # if tests returned 0 - success!
    if [ $? -eq 0 ]; then
        echo "$(attempt-status-alert 42 $i $MODULE "tests succeeded")"
        break
    # otherwise - tests failed
    else
        # if last attempt - give up
        if [ $i -eq $ATTEMPTS ]; then
            echo "$(attempt-status-alert 41 $i $MODULE "tests failed")"
        # otherwise - run cleanup (takes half a minute)
        else
            echo "$(attempt-status-alert 43 $i $MODULE "running cleanup and trying again ...")"
            npm run cleanup
        fi
    fi
done
