#!/bin/sh

# Exit on error
set -e

# This script is used to run the Playwright tests in a container
# usage: ./docker_run.sh
# Or to refresh the Cmfive Docker containers before running the tests
# usage: ./docker_run.sh --fresh

# Bootstrap this script in the Playwright container
if [ -z "$IS_PLAYWRIGHT_CONTAINER" ]; then
    # Explicitly prep DB for testing:
    echo "Backup and snaphsot DB with migrations"
    if docker exec -t cmfive bash -c "php cmfive.php testDB setup"; then
        echo "Success: Setup test DB"
    else
        echo "Warning: Failed to setup test DB"
    fi

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

    docker build -t playwright-cosine -f $TESTDIR/playwright.Dockerfile $PROJECTDIR

    set +e

    docker run -it --rm \
        -e IS_PLAYWRIGHT_CONTAINER=1 \
        -e LANG=en_AU.UTF-8 \
        -e LC_ALL=en_AU.UTF-8 \
        -v ms-playwright-data-cmfive:/ms-playwright \
        -v $PROJECTDIR:/cmfive-boilerplate \
        --ipc=host \
        --network=host \
        --cap-add=SYS_ADMIN \
        playwright-cosine \
        "/cmfive-boilerplate/test/playwright/docker_run.sh"
        
    DOCKER_EXIT_CODE=$?

    set -e

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

    if [ $DOCKER_EXIT_CODE -ne 0 ]; then
        echo "Playwright container exited with code $DOCKER_EXIT_CODE"
        exit $DOCKER_EXIT_CODE
    fi

    echo "Success: Playwright tests completed"
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

wait_for_response "http://localhost:3000" 60

locale
date

cd /cmfive-boilerplate/test/playwright
npm i
npm run build

# Run the tests, recommended 1 worker for Playwright for memory usage
export WORKERS=1

# Retry failed tests, recommended 0 retries because of data consistency
export RETRIES=0

npm run test

