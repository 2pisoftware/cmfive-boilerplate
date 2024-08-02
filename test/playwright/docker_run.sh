#!/bin/sh

# This script is used to run the Playwright tests in a container
# usage: ./docker_run.sh
# Or to refresh the Cmfive Docker containers before running the tests
# usage: ./docker_run.sh --fresh

# Bootstrap this script in the Playwright container
if [ -z "$IS_PLAYWRIGHT_CONTAINER" ]; then
    # Get the directory of the script
    TESTDIR=$(dirname -- "$( readlink -f -- "$0"; )";)
    
    # Go up one directory from DIR until docker-compose.yml is found
    PROJECTDIR=$TESTDIR
    while [ ! -f "$PROJECTDIR/docker-compose.yml" ]; do
        PROJECTDIR="$(dirname "$PROJECTDIR")"
    done

    # if the --fresh flag is set, refresh the Cmfive Docker containers
    if [ "$1" = "--fresh" ]; then
        echo "Refreshing Cmfive Docker containers"
        docker compose down -v
        docker compose up -d --wait
    fi

    docker run -it --rm \
         -e IS_PLAYWRIGHT_CONTAINER=1 \
         -v $PROJECTDIR:/cmfive-boilerplate \
         -v ms-playwright-data-cmfive:/ms-playwright \
         --ipc=host \
         --network=host \
         --user $(id -u):$(id -g) \
         --cap-add=SYS_ADMIN \
         mcr.microsoft.com/playwright:v1.45.1-jammy \
         /cmfive-boilerplate/test/playwright/docker_run.sh
    
    # Open ./test-results in the default file manager
    if [ -d $TESTDIR/test-results ]; then
        if which xdg-open > /dev/null; then
            xdg-open $TESTDIR/test-results
        elif which open > /dev/null; then
            open $TESTDIR/test-results
        fi
    fi
    
    exit
fi

wait_for_response() {
    local url=$1
    local timeout=$2

    echo "Waiting for $url to respond"
    for i in $(seq 1 $timeout); do
        if curl -s -o /dev/null -w "%{http_code}" "$url"; then
            echo -n "."
            break
        fi
        sleep 1
    done

    if [ $i -eq $timeout ]; then
        echo "Failed to get a response from $url"
        exit 1
    fi
    echo ""
    echo "$url responded"
}   

cd /cmfive-boilerplate/test/playwright

npm i
npx playwright install
npm run setup
npm run build
npm run cleanup

wait_for_response "http://localhost:3000" 30

export WORKERS=3
export RETRIES=2

npm run test

