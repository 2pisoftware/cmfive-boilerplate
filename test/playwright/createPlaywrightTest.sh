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

# Copy boilerplate test file to module's playwright test directory
cp $playwright_dir_abs/test_boilerplate.ts ./tests/acceptance/playwright/${module_name}.test.ts

# Generate tsconfig.json for this module's playwright test directory
# imports of the form `@utils/*` get mapped to `playwright_dir_rel/utils/*`
# maps all other imports to `playwright_dir_rel/node_modules/*` or `playwright_dir_rel/*`
jq --arg playwright_dir_rel "$playwright_dir_rel" '.compilerOptions.baseUrl = $playwright_dir_rel' $playwright_dir_abs/test_boilerplate.tsconfig.json > ./tests/acceptance/playwright/tsconfig.json