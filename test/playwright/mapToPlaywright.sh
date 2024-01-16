#!/bin/bash

to_relative_path() {
    # The target path is the first argument
    local target_path=$1

    # The base path is the second argument or the current working directory if not provided
    local base_path=${2:-$(pwd)}

    # Use realpath command to compute the relative path
    echo "$(realpath --relative-to="$base_path" "$target_path")"
}

# Get name of module and create playwright test directory structure
module_name=$(basename $(pwd))
mkdir -p ./tests/acceptance/playwright/

# Get the absolute path of the base playwright directory (the directory containing this script)
playwright_dir_abs=$(cd $(dirname "$0") && pwd -P)

# Get relative path to the base playwright directory from module's playwright test directory
playwright_dir_rel=$(to_relative_path $playwright_dir_abs ./tests/acceptance/playwright/)

# Check if the playwright test file for the module already exists
if [ ! -f ./tests/acceptance/playwright/${module_name}.test.ts ]; then
    # Copy boilerplate test file to module's playwright test directory if test file not present
    cp $playwright_dir_abs/test_boilerplate.ts ./tests/acceptance/playwright/${module_name}.test.ts
fi

# Check if tsconfig.json exists
if [ -f ./tests/acceptance/playwright/tsconfig.json ]; then
    # Update the baseUrl of the pre-existing tsconfig.json
    jq --arg playwright_dir_rel "$playwright_dir_rel" '.compilerOptions.baseUrl = $playwright_dir_rel' ./tests/acceptance/playwright/tsconfig.json > ./tests/acceptance/playwright/tsconfig.tmp.json && mv ./tests/acceptance/playwright/tsconfig.tmp.json ./tests/acceptance/playwright/tsconfig.json
else
    # Generate new tsconfig.json if it doesn't exist
    jq --arg playwright_dir_rel "$playwright_dir_rel" '.compilerOptions.baseUrl = $playwright_dir_rel' $playwright_dir_abs/test_boilerplate.tsconfig.json > ./tests/acceptance/playwright/tsconfig.json
fi
