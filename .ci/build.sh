#!/bin/bash

# NOTICE:
# This file is supposed to only run in travis
# You should not try to run it locally

set -o errexit -o nounset

if [ "${TRAVIS_BRANCH}" == "staging" ]; then
  # Get deps and compile for test and prod release
  mix deps.get
  MIX_ENV=test mix compile --warnings-as-errors
  MIX_ENV=prod mix compile

  # Install nodejs 6.9 LTS
  nvm install 6.9
  nvm use 6.9

  # Install npm packages for frontend
  MIX_ENV=test mix frontend.install
fi
