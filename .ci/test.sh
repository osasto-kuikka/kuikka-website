#!/bin/bash

# NOTICE:
# This file is supposed to only run in travis
# You should not try to run it locally

set -o errexit -o nounset

if [ "${TRAVIS_BRANCH}" = "staging" ] || [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  # Run tests
  mix test

  # Run linter
  MIX_ENV=test mix lint

  # Build production release for test
  MIX_ENV=prod mix release --warnings-as-errors --env=prod
fi
