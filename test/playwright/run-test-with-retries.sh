#!/bin/bash

# The first argument is the module name
MODULE=$1

# The second argument is the reporter, with "github" as the default if not provided
REPORTER=${2:-"github"}

cd test/playwright
npm run build

success=false

for i in 1 2 3; do
    npm run test --module="$MODULE" --reporter="$REPORTER"
    if [ $? -eq 0 ]; then
        echo "$MODULE module tests succeeded on attempt $i"
        success=true
        break
    else
        echo "Attempt $i for $MODULE module failed, running cleanup and retrying..."
        npm run cleanup
    fi
done

if [ "$success" = false ]; then
    echo "$MODULE module tests failed after 3 attempts"
    exit 1
fi
