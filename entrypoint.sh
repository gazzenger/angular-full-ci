#!/bin/sh

set -e

audit_level="$INPUT_AUDIT_LEVEL"
buildcommand="$INPUT_BUILDCOMMAND"
testcommand="$INPUT_TESTCOMMAND"
mocha="$INPUT_MOCHA"
working_dir="$INPUT_WORKING_DIRECTORY"

if [ -n "$working_dir" ]; then
    cd $working_dir
fi

npm config set fetch-retry-mintimeout 100000
npm config set fetch-retry-maxtimeout 600000
npm config set cache-min 3600

echo "\n**Upgrading npm**\n"
npm install -g npm@latest
npm install -g n
n 16.14.0
n prune

echo "\n**Auditing Packages**\n"
npm audit --omit dev  --audit-level "$audit_level"

if [ "$mocha" = "true" ]; then
    npm i mocha
fi

echo "\n**Installing Dependencies**\n"
npm install --fetch-timeout=600000

echo "\n**Linting Code**\n"
npm run lint

echo "\n**Building Project**\n"
npm $buildcommand

echo "\n**Running Unit Tests**\n"
npm $testcommand
