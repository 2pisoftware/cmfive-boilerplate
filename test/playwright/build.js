const glob = require('glob');
const fs = require('fs');
const path = require('path');

function copyFiles(sourceGlob, destDir, rename = filename => filename) {
    // Find all files and directories that match the glob pattern
    glob(sourceGlob, { nodir: true }).then(files => {
        // Create the destination directory if it doesn't exist
        if (!fs.existsSync(destDir)) {
            fs.mkdirSync(destDir);
        }

        // Copy each file to the destination directory
        files.forEach(file => {
            const filename = rename(path.basename(file));
            const destFile = path.join(destDir, filename);
            fs.copyFileSync(file, destFile);
        });
    }).catch(err => {
        console.error(err);
    })
}

// pull all module test files into src directory
copyFiles('../../system/modules/**/tests/acceptance/playwright/*.test.ts', './src')
copyFiles('../../modules/**/tests/acceptance/playwright/*.test.ts', './src')

// pull all module test util files into one directory for scoping
copyFiles('../../system/modules/**/tests/acceptance/playwright/*.utils.ts', './src/utils',
    filename => filename.replace('.utils.ts', '.ts')
);
copyFiles('../../modules/**/tests/acceptance/playwright/*.utils.ts', './src/utils',
    filename => filename.replace('.utils.ts', '.ts')
);