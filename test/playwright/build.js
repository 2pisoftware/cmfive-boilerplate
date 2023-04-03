const glob = require('glob');
const fs = require('fs');
const path = require('path');

function copyFiles(sourceGlob, destDir) {
    // Find all files and directories that match the glob pattern
    glob(sourceGlob, { nodir: true }).then(files => {
        // Create the destination directory if it doesn't exist
        if (!fs.existsSync(destDir)) {
            fs.mkdirSync(destDir);
        }

        // Copy each file to the destination directory
        files.forEach(file => {
            console.log("file", file)
            const fileName = path.basename(file);
            const destFile = path.join(destDir, fileName);
            fs.copyFileSync(file, destFile);
        });
    }).catch(err => {
        console.error(err);
    })
}

// Copy the test files to the build directory

copyFiles('../../system/modules/**/tests/playwright/*.test.ts', './src');
copyFiles('../../modules/**/tests/playwright/*.test.ts', './src');
