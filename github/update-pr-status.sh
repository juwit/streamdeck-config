#!/bin/bash

REPO=$1
PR=$2
KEY=$3

echo "Getting Pull Request Global check status"
PR_STATUS="check"

echo "get PR commit id"
COMMIT_ID=$(curl -s https://api.github.com/repos/$REPO/pulls/$PR | jq -r ".head.sha")
echo "get status for commit $COMMIT_ID"

CHECKS_CONCLUSIONS=$(curl -s https://api.github.com/repos/$REPO/commits/$COMMIT_ID/check-runs | jq -r ".check_runs[].conclusion")

echo $CHECKS_CONCLUSIONS

for conclusion in $CHECKS_CONCLUSIONS
do
  if [ "$conclusion" = "failure" ]; then
    # any failure means the PR is a failure
    PR_STATUS="cancel"
    break;
  fi
done

# now update the key !
echo "Update key for status $PR_STATUS"
curl -s \
  -X POST http://localhost:8081/pages/github/buttons/$KEY \
  --header "Content-Type: application/json" \
  --data-binary @- << EOF
  {
    "icon": "/home/jwittouck/workspaces/streamdeck/github/$PR_STATUS.png",
    "command": "firefox https://github.com/$REPO/pull/$PR"
  }
EOF
