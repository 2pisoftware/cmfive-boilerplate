#!/bin/bash

BASE_DIR="/workspaces/codespace_dev_box/cmfive-core/system/modules"

matches=$(find "$BASE_DIR" -path "*/install/migrations/*_TestMigration.php")

if [ -z "$matches" ]; then
  echo -e "\n\033[0;33mNo migration test files found.\033[0m"
  exit 0
fi

declare -a deletable
declare -a undeletable

for file in $matches; do
    if [ -f "$file" ] && [ -w "$(dirname "$file")" ]; then
        deletable+=("$file")
    else
        undeletable+=("$file")
    fi
done

if [ ${#undeletable[@]} -ne 0 ]; then
    echo -e "\n\033[0;41mThese files cannot be deleted using the current permissions (you might need to use sudo):\033[0m"
    echo -e -n "\033[0;31m"
    for file in "${undeletable[@]}"; do
        echo "    $file"
    done
    echo -e -n "\033[0m"
fi

if [ ${#deletable[@]} -ne 0 ]; then
    echo -e "\n\033[0;42mThese files can be deleted using the current permissions:\033[0m"

    echo -e -n "\033[0;32m"
    for file in "${deletable[@]}"; do
        echo "    $file"
    done
    echo -e -n "\033[0m"

    echo
    echo -e "\033[0;33m"
    read -p "Do you want to delete the files you have permission to delete? (y/n) " confirm_delete
    echo -e "\033[0m"

    if [[ "$confirm_delete" =~ ^[Yy]$ ]]; then
        for file in "${deletable[@]}"; do
            rm -v "$file"
        done
    else
        echo "No files deleted."
    fi
else
    echo -e "\nThere are no files to delete with the current permissions."
fi