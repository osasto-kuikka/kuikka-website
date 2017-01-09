#!/bin/bash

if [ "${TRAVIS_BRANCH}" = "master" ] && [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
  # Init git configs for kuikkabot
  git init
  git config user.name "kuikkabot"
  git config user.email "kuikkabot@gmail.com"

  # Set remote with gh token
  git remote add upstream "https://$GH_TOKEN@github.com/osasto-kuikka/kuikka-website.git"
  git fetch upstream
  git reset upstream/master

  # Generate new docs
  mix docs

  # Remove old docs and move new from doc to docs
  rm -rf docs
  mv doc docs

  # Commit changes and push to master
  git add docs
  git commit -m "Updated docs [ci skip]"
  git push -q upstream HEAD:master
fi
