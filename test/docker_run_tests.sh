#!/bin/sh

# Script will self manage errors:
set +e

# This script is used to run the Playwright tests in a container
# usage: ./docker_run.sh
# Or to refresh the Cmfive Docker containers before running the tests
# Node version can be specified, WARNING Playwright&Cosine will not be expected to support all node versions!
# usage: ./docker_run.sh --fresh
# usage: ./docker_run.sh --node_ver 18
# usage: ./docker_run.sh --cosine_container [default is 'cmfive']

freshen_all=""
test_node_version=""
cosine_container="cmfive"

while test $# != 0
do
    case "$1" in
    --fresh) freshen_all=true ;;
    --node_ver)
        shift; test_node_version=$1 ;;
    --) shift; break;;
    --cosine_container)
        shift; cosine_container=$1 ;;
    --) shift; break;;
    esac
    shift
done

# Bootstrap this script in the Playwright container
if [ -z "$IS_PLAYWRIGHT_CONTAINER" ]; then


    # Get the directory of the script
    TESTDIR=$(dirname -- "$( readlink -f -- "$0"; )";)
    
    # Go up one directory from DIR until docker-compose.yml is found
    PROJECTDIR=$TESTDIR
    while [ ! -f "$PROJECTDIR/docker-compose.yml" ]; do
        PROJECTDIR="$(dirname "$PROJECTDIR")"
        echo "PROJECTDIR: $PROJECTDIR"
        echo "TESTDIR: $TESTDIR"
        if [ "$PROJECTDIR" = "/" ]; then
            echo "Panic: docker-compose.yml not found, be sure to run this script from the test directory"
            exit 2
        fi
    done

    # if the --fresh flag is set, refresh the Cmfive Docker containers
    if [ ! -z $freshen_all ]; then
        echo "Refreshing Cmfive Docker containers"
        docker compose down -v
        docker compose up -d --wait
    fi
    
    system_is_at=$(readlink -f $PROJECTDIR/system)
    PAGER=cat
    echo ">> CONTAINER LABELS (BOILERPLATE) <<"
    echo "===================================="
    docker inspect --format='{{range $key, $value := .Config.Labels}}{{$key}}={{$value}}{{println}}{{end}}' cmfive
    echo ">> CONTAINER LABELS (CORE COMMIT) <<"
    echo "===================================="
    echo "VENDOR DIRECTORY:"
    docker exec -u cmfive -e PAGER=$PAGER $cosine_container sh -c "cd composer/vendor/2pisoftware/cmfive-core && git log -1 --pretty=format:"CORE_HASH=\"%H\"%nCORE_COMMIT_MSG=\"%s\"%nCORE_REF=\"%D\"""
    echo ""
    if cd $system_is_at/.. ; then
        echo ""
        echo ">> TESTS ON BRANCH (CORE COMMIT) <<"
        echo "===================================="
        echo "MOUNTED CORE from $system_is_at: (this is mounted to /system)"
        git log -1 --pretty=format:"CORE_HASH=\"%H\"%nCORE_COMMIT_MSG=\"%s\"%nCORE_REF=\"%D\""
        echo ""
    fi
    sysdir=`basename "$system_is_at"`
    coredir=`dirname "$system_is_at"`
    coredir=`basename "$coredir"`

    # Explicitly prep DB for testing:
    echo "Backup and snaphsot DB with migrations"
    docker exec -u cmfive $cosine_container sh -c "DB_HOST=mysql-8 DB_USERNAME=$DB_USERNAME DB_PASSWORD=$DB_PASSWORD DB_DATABASE=$DB_DATABASE DB_PORT=3306 php cmfive.php testDB setup"
    DB_SETUP_EXIT_CODE=$?
    if [ $DB_SETUP_EXIT_CODE -ne 0 ]; then
        echo "Warning: Failed to setup test DB"
        exit $DB_SETUP_EXIT_CODE
    fi
    echo "Success: Setup test DB"

    # First, Run Unit Tests
    docker exec -u cmfive $cosine_container sh -c "DB_HOST=mysql-8 DB_USERNAME=$DB_USERNAME DB_PASSWORD=$DB_PASSWORD DB_DATABASE=$DB_DATABASE DB_PORT=3306 php cmfive.php tests unit all; exit \$?"
    UNIT_TESTS_EXIT_CODE=$?
    if [ $UNIT_TESTS_EXIT_CODE -ne 0 ]; then
        echo "Unit tests failed: $UNIT_TESTS_EXIT_CODE"
        exit $UNIT_TESTS_EXIT_CODE
    fi
    echo "Unit tests passed"

    docker build -t playwright-cosine -f $TESTDIR/test_service.Dockerfile $PROJECTDIR

    # Tests SHOULD assume playwright code is executable
    # but if this script is not -x- the container won't launch!
    # sudo chmod 755 $TESTDIR/docker_run_tests.sh

    echo ""
    echo "Tests will collate from: /$coredir/$sysdir"
    echo "and from: /cmfive-boilerplate/modules"
    docker run -t --rm \
        -e IS_PLAYWRIGHT_CONTAINER=1 \
        -e LANG=en_AU.UTF-8 \
        -e LC_ALL=en_AU.UTF-8 \
        -e TEST_NODE_VERSION=$test_node_version \
        -v ms-playwright-data-cmfive:/ms-playwright \
        -v $PROJECTDIR:/cmfive-boilerplate \
        -v $system_is_at:"/$coredir/$sysdir" \
        --ipc=host \
        --network=host \
        --cap-add=SYS_ADMIN \
        playwright-cosine \
        "/cmfive-boilerplate/test/docker_run_tests.sh"
        
    DOCKER_EXIT_CODE=$?

    set -e

    # OK, now we are done with the Playwright container
    # Consider cleanup:
    # We can hold the DB as-is, for further manual testing.
    # But should clean up migration artefacts, to avoid git diff.
    cd $TESTDIR/playwright
    bash ./cleanupTestMigrations.sh --no-confirm
    # but no: npm run cleanup
    
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

# Tests will assume playwright code is executable
# we should rely on deployment methods already to have provisioned:
# chmod -R 755 .
whoami
locale
date

# if TEST_NODE_VERSION is set, adopt version

if [ ! -z $TEST_NODE_VERSION ]; then
    echo "Switching node version"
    n $TEST_NODE_VERSION
    hash -r
fi

echo ""
echo "Node is reporting:"
node --version

cd /cmfive-boilerplate/test/playwright

echo "DB snapshot is latest from:"
ls ../Databases -lah

npm ci
npx playwright install --with-deps
npm run build
ls src -lah

# Run the tests, recommended 1 worker for Playwright for memory usage
export WORKERS=1

# Retry failed tests, recommended 0 retries because of data consistency
export RETRIES=0

npm run test 
PLAYWRIGHT_TESTS_EXIT_CODE=$?
    if [ $PLAYWRIGHT_TESTS_EXIT_CODE -ne 0 ]; then
        echo "Playwright tests failed: $PLAYWRIGHT_TESTS_EXIT_CODE"
        exit $PLAYWRIGHT_TESTS_EXIT_CODE
    fi

echo "Playwright tests passed"

