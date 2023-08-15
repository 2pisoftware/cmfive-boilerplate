# Get Cmfive Working
- Use this codespace: https://github.com/2pisoftware/codespace_dev_box/tree/BoilerplateCore_Modules_Tests_Debug
- Open in VS Code Desktop
- Wait for everything to be setup, then right click on the nginx webapp container and `Open In Browser`
- If the webpage gives a MONOLOGGER error, run `bash ./.codespaces/scripts/02_postCreateScript.sh`
- If not, Cmfive is ready for your Playwright tests


# Get Playwright Working
- Grab the latest version of nvm from https://nvm.sh using the `curl` command
- Close the current terminal after nvm is downloaded, and open a new terminal
- cd cmfive-boilerplate
- git switch feature/PlaywrightMigration

- nvm install 12
- nvm use 12
- cd system/templates/base
- npm i
- npm run dev

- cd ../../../test/playwright
- nvm install 18
- nvm use 18
- npm i
- npx playwright install
- npx playwright install-deps


# Run Playwright Tests
- npx playwright test (cwd should be cmfive-boilerplate/test/playwright/)