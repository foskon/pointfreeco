#!/usr/bin/env bash

echo "Running post-commit hook"

# # PATH to the repository of interest
# export PATH=$PATH:/Users/cmanzanas/Documents/Projects/hwsui/.git/hooks

toplevel_path=`git rev-parse --show-toplevel`
toplevel_dir=`basename "$toplevel_path"`

# this variable holds the branch you are working on
branch=`git rev-parse --abbrev-ref HEAD`
# this variable holds the actual commit message
subject=`git log --pretty=format:%s -n1`
# this variables adds some hashtags to your tweet "#code #(name of your repo)"
hashtags="Repository: $toplevel_dir"
#the tweet itself is thee hashtags plus the branch name plus the commit message
tweet=$hashtags' ['$branch']: "'$subject'"'

# truncate tweets that are longer than 280 characters
if [ ${#tweet} -gt 280 ]
    then
        tweet_trunc=$(echo $tweet | cut -c1-277)
        tweet=${tweet_trunc}...
fi

export tweet

./scripts/run-tweet.bash

# $? stores exit value of the last command
if [ $? -ne 0 ]; then
 echo "Code must be clean before commiting"
 exit 1
fi
