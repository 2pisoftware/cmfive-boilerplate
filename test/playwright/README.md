# Get Cmfive Working

- Use this codespace: https://github.com/2pisoftware/codespace_dev_box/tree/BoilerplateCore_Modules_Tests_Debug
- Open in VS Code Desktop
- Wait for everything to be setup, then right click on the nginx webapp container and `Open In Browser`
- If the webpage gives a MONOLOGGER error, run `bash ./.codespaces/scripts/02_postCreateScript.sh`
- If not, Cmfive is ready for your Playwright tests

# Download nvm

- Grab the latest version of nvm from https://nvm.sh using the `curl` command
- Close the current terminal after nvm is downloaded, and open a new terminal

# Use the feature/PlaywrightMigration branch as the cmfive-boilerplate repo

- cd cmfive-boilerplate
- git switch feature/PlaywrightMigration

# Use the feat/AdminBootstrap5 branch as the cmfive-core repo

- cd ../cmfive-core
- git switch feat/AdminBootstrap5

# Ensure styles are compiled

- cd ../cmfive-core/system/templates/base
- nvm install 14
- nvm use 14
- npm i
- npm run dev

# Setup Playwright

- cd ../../../test/playwright
- nvm install 18
- nvm use 18
- npm i
- npx playwright install
- npx playwright install-deps

# Run Playwright Tests

- cwd should be cmfive-boilerplate/test/playwright/
- npm run build
- npx playwright test --project=chromium