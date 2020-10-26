#!/usr/bin/env bash

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

set -e

cd "${0%/*}/.."

echo "Running Tweet..."
echo $tweet

bundle exec ruby scripts/tweet.rb "${tweet}"
