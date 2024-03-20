# Get Cmfive Working

- Bring cmfive up using standard docker compose tools
- Wait for everything to be setup, then right click on the nginx webapp container and `Open In Browser`
- If the webpage gives a MONOLOGGER error, run `bash ./.codespaces/scripts/02_postCreateScript.sh`
- If not, Cmfive is ready for your Playwright tests

# Download nvm

- Grab the latest version of nvm from https://nvm.sh using the `curl` command
- Close the current terminal after nvm is downloaded, and open a new terminal
- `nvm install 20`
- `nvm use 20`

# Use the develop branch as the cmfive-boilerplate repo

- `cd cmfive-boilerplate`
- `git switch develop`

# Use the develop branch as the cmfive-core repo

- `cd ../cmfive-core`
- `git switch develop`

# Ensure styles are compiled

- `cd ./composer/vendor/2pisoftware/cmfive-core/system/templates/base`
- `npm i`
- `npm run dev`

# Setup Playwright

- `cd ../../../../cmfive-boilerplate/test/playwright`
- `npm i`
- `npx playwright install`
- `npx playwright install-deps`
- `npm run setup`
- `npm run build` (run this every time you have changes to a test or utils file that you want to include in the next test run, and for utils files specifically those changes to be present when importing via `@utils/*`)

# Run Playwright Tests

- cwd should be `cmfive-boilerplate/test/playwright/`
- `npm run cleanup` (important! do this every time before you run tests on a system after already having done so previously)
- `npm run test`
- to run tests for a specific platform: `npm run test --platform="[insert browser]"`
    - Example: `npm run test --platform="firefox"`
- to run a specific test file: `npm run test --module="[insert test file name]"`
    - Example: `npm run test --module="admin"`
    - see: https://playwright.dev/docs/test-cli (look for `--grep` instead of `--module`)
- if you want your tests to be attempted a certain number of times (for flaky tests) when they fail: `npm run test:with-retries`
    - Example: `npm run test:with-retries --module="task|timelog" --attempts=2 --clean` (`--clean` runs `npm run cleanup` BEFORE your tests run if you have a possibly dirty setup, the script automatically handles the rest of the cleanups for retries)

# Setting up a new Playwright test for a module

- cd into the top level of the module (for example, cwd could be `cmfive-core/system/modules/help`)
- `bash /workspaces/codespace_dev_box/cmfive-boilerplate/test/playwright/mapToPlaywright.sh`
- the above script should be run whenever the relative path between a module and the base playwright directory in `cmfive-boilerplate` changes
- `*.test.ts` files contain the actual test code
- `*.utils.ts` files contain utility functions for a given module
    - util files are imported like so: `import { AdminHelper } from '@utils/admin'`, without `.utils.ts` file extension