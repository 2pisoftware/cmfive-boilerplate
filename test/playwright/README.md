# Get Cmfive Working

- Use this codespace: https://github.com/2pisoftware/codespace_dev_box/tree/BoilerplateCore_Modules_Tests_Debug
- Open Codespace using your local VS Code using Remote Explorer extension for VS Code
- Wait for everything to be setup, then right click on the nginx webapp container and `Open In Browser`
- If the webpage gives a MONOLOGGER error, run `bash ./.codespaces/scripts/02_postCreateScript.sh`
- If not, Cmfive is ready for your Playwright tests

# Download nvm

- Grab the latest version of nvm from https://nvm.sh using the `curl` command
- Close the current terminal after nvm is downloaded, and open a new terminal

# Use the feature/PlaywrightMigration branch as the cmfive-boilerplate repo

- `cd cmfive-boilerplate`
- `git switch feature/PlaywrightMigration`

# Use the feature/FormBS5Conversion branch as the cmfive-core repo

- `cd ../cmfive-core`
- `git switch feature/FormBS5Conversion`

# Ensure styles are compiled

- `cd ../cmfive-core/system/templates/base`
- `nvm install 14`
- `nvm use 14`
- `npm i`
- `npm run dev`

# Setup Playwright

- `cd ../../../../cmfive-boilerplate/test/playwright`
- `nvm install 18`
- `nvm use 18`
- `npm i`
- `npx playwright install`
- `npx playwright install-deps`

# Run Playwright Tests

- cwd should be `cmfive-boilerplate/test/playwright/`
- `npm run build`
- `npm run test`
- to run tests for a specific platform: `npx playwright test --project=[insert browser]`
    - Example: `npx playwright test --project=chromium`
- to run a specific test file: `npx playwright test --grep "[insert test file name]"`
    - Examples:
        - `npx playwright test --grep "admin"`,
        - `npx playwright test --grep "admin.test"`,
        - `npx playwright test --grep "admin.test.ts"`,
    - you can also run tests where the test's description name (if present) matches the regex of `--grep "[regex here]"`; see: https://playwright.dev/docs/test-cli
    - to run run all tests EXCEPT those that match a given regex, use `--grep-invert` instead of `--grep`
- you MUST run `npm run build` for your latest changes to test/test utils files to be made available for import (see "Setting up a new Playwright test for a module"), as well as for those changes to be present when running `npm run test`
- before running Playwright tests, you should set up your Cmfive instance with an "Empty TestRunner DB and Administrator":
    - Attach shell to cmfive's nginx container
    - `php cmfive.php`
    - Enter command option `9`

# Setting up a new Playwright test for a module

- cd into the top level of the module (for example, cwd could be `cmfive-core/system/modules/help`)
- `bash /workspaces/codespace_dev_box/cmfive-boilerplate/test/playwright/mapToPlaywright.sh`
- the above script should be run whenever the relative path between a module and the base playwright directory in `cmfive-boilerplate` changes
- `*.test.ts` files contain the actual test code
- `*.utils.ts` files contain utility functions for a given module
    - util files are imported like so: `import { AdminHelper } from '@utils/admin'`, without `.utils.ts` file extension
    - you MUST run `npm run build` from `cmfive-boilerplate/test/playwright/` before changes to `xyz.utils.ts` are propagated to files importing `@utils/xyz`