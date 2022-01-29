#!/bin/sh

set -e

audit_level="$INPUT_AUDIT_LEVEL"
testcommand="$INPUT_TESTCOMMAND"
mocha="$INPUT_MOCHA"
working_dir="$INPUT_WORKING_DIRECTORY"

if [ -n "$working_dir" ]; then
    cd $working_dir
fi

echo "\n**Upgrading npm**\n"
npm install -g npm@latest

echo "\n**Auditing Packages**\n"
npm audit --audit-level "$audit_level"

if [ "$mocha" = "true" ]; then
    npm i mocha
fi

echo "\n**Installing Dependencies**\n"
npm install

echo "\n**Linting Code**\n"
npm run lint

echo "\n**Building Project**\n"
npm run build --prod

echo "\n**Running Unit Tests**\n"
npm $testcommand
