#!/bin/bash

set -euo pipefail

if [ "${PROMISES}" = "bluebird" ]; then
  npm install bluebird
fi

npm test

if [ "${TRAVIS_NODE_VERSION}" = "4" ] && [ "${PROMISES}" = "native" ]; then
  npm run coverage
  npm run lint
else
  echo "Not running coverage and linting..."
fi
