#!/bin/sh

# This script is used to run the Playwright tests in a container
# usage: ./docker_run.sh
# Or to refresh the Cmfive Docker containers before running the tests
# usage: ./docker_run.sh --fresh

# Bootstrap this script in the Playwright container
if [ -z "$IS_PLAYWRIGHT_CONTAINER" ]; then
    # Explicitly prep DB for testing:
    echo "Backup and snaphsot DB with migrations"
    docker exec -t cmfive bash -c "php cmfive.php testDB setup"

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
         --cap-add=SYS_ADMIN \
         mcr.microsoft.com/playwright:v1.45.1-jammy \
         "/cmfive-boilerplate/test/playwright/docker_run.sh"

    # OK, now we are done with the Playwright container
    # Consider cleanup:
    # We can hold the DB as-is, for further manual testing.
    # But should clean up migration artefacts, to avoid git diff.
    bash cleanupTestMigrations.sh 
    # but no: npm run cleanup
    
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


# Australianise things:
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
locale-gen en_AU.UTF-8
update-locale en_AU.UTF-8
LANG=en_AU.UTF-8
LC_ALL=en_AU.UTF-8
locale

apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
date

# Shift into test environment
cd /cmfive-boilerplate/test/playwright

npm i
npx playwright install
npm run build
# we don't need setup, as we intitiated it already from host CLI scope, before test container re-entry.
# so, no: npm run setup

wait_for_response "http://localhost:3000" 30

export WORKERS=1

# unless we restore our 'empty' target DB, we cannot achieve useful retries!
# this is the purpose of "npm_config_clean=true"
# but node (from in here) will make a mess of the Playwright package.json Docker assumptions.
export RETRIES=0

npm run test

