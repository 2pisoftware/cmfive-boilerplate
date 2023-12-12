#!/bin/bash

MODULE=${1:-""}
BROWSER=${2:-"chromium"}
REPORTER=${3:-"github"}

success=false

for i in 1 2 3; do
    npm run test --module=$MODULE --platform=$BROWSER --reporter=$REPORTER

    if [ $? -eq 0 ]; then
        if [ -z "$MODULE" ]; then echo "Attempt $i: tests succeeded"
        else echo "Attempt $i for $MODULE: tests succeeded"
        fi
        
        exit 0
    else
        if [ $i -eq 3 ]; then
            if [ -z "$MODULE" ]; then echo "Tests failed after 3 attempts"
            else echo "$MODULE module tests failed after 3 attempts"
            fi

            exit 1
        fi

        if [ -z "$MODULE" ]; then echo "Attempt $i: tests failed, running cleanup and retrying..."
        else echo "Attempt $i for $MODULE: tests failed, running cleanup and retrying..."
        fi

        npm run cleanup
    fi
done
