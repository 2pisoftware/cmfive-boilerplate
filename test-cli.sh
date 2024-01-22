#!/usr/bin/env bash

# Verify that we have arguments
if [ $# -eq 0 ]
then
    echo "No arguments supplied"
fi

echo "Running $1 tests (reporter: $2)"

SCRIPT_DIR=$(pwd)

MODULE=$1
REPORTER=${2:-"list"}
BROWSER="${3@Q}"
# Go into Playwright test directory
cd test/playwright

# Run tests
npm run build

if [ -z "$BROWSER" ]
then
    npx playwright test --reporter $REPORTER --grep "$MODULE"
else
    npx playwright test --project $BROWSER --reporter $REPORTER --grep "$MODULE"
fi

# Go back to script directory
cd $SCRIPT_DIR
