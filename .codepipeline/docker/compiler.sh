#!/bin/ash

echo ""
echo "========================="
echo "  Cmfive theme compiler"
echo "========================="
echo ""

echo "=== 🧱 Preparing ==="

waitForFile() {
    local file="$1"
    if [ ! -f "$file" ]; then
        while [ ! -f "$file" ]; do
            echo "Waiting for file $file "
            sleep 5
        done
        echo ""
    fi
}

waitForFile "/var/www/html/system/templates/base/package.json"
 
cd "/var/www/html/system/templates/base"

echo "=== 📦 Installing npm packages ==="

npm i

echo "=== ✔️ Starting compiler ==="

npm run watch

echo "=== ❌ Compiler exited ==="
