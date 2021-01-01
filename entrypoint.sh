#!/bin/bash

set -u
# Note:exit 0 stands for success

#get 1st argument from command line input vaiables and store in repo_token
repo_token=$1

if ["$GITHUB_EVENT_NAME"!="milestone"];then
    echo "::debug::The event name was '$GITHUB_EVENT_NAME'"
    exit 0 
fi

event_type=$(jq --raw-output .action $GITHUB_EVENT_PATH)

if [$event_type != 'closed'];then
    echo "::debug::The event type was '$event_type'"
    exit 0
fi

milestone_name=$(jq --raw-output .miletsone .title $GITHUB_EVENT_PATH) 

#IFA=internal field seperator
#<<< Here-string redirection operator
#This statement takes the input as GITHUB_REPOSITORY and splits it into
#owner and repository using the IFA read command with seperator '/'
IFS='/' read owner repository <<< "$GITHUB_REPOSITORY"

release_url=$(dotnet gitreleasemanager create \
-- milestone $milestone_name \
-- targetcommitish $GITHUB_SHA \
-- token $repo_token \
-- owner $owner \
-- repository $repository)

#$? stands for error code
if [ $? -ne 0];then
    echo "::error::Failed to create the release draft"
    exit 1
fi

echo ::set-output name=release-url::$release_url

exit 0

