#!/bin/bash

# NOTICE:
# This file is supposed to only run in travis
# You should not try to run it locally

set -o errexit -o nounset

if [ "${TRAVIS_BRANCH}" = "master" ] && [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
  # Generate new docs and cd to it
  mix docs
  cd doc

  # Init git configs for kuikkabot
  git init
  git config user.name "kuikkabot"
  git config user.email "kuikkabot@gmail.com"

  # Set remote with gh token
  git remote add upstream "https://$GH_TOKEN@github.com/osasto-kuikka/kuikka-website.git"
  git fetch upstream
  git reset upstream/gh-pages

  # Commit changes and push to master
  git add --all
  git commit -m "Updated docs from master [ci skip]"
  git push -q upstream HEAD:gh-pages
fi
