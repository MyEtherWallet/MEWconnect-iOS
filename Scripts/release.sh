#!/bin/sh
RELEASE="$1"
GITHUB_TOKEN="$2"
REPO="$3"
CHANGELOG=`awk -v version="$RELEASE" '/### Release / {printit = $3 == version}; printit;' 'CHANGELOG.md'`
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$REPO"
AUTH="Authorization: token ${GITHUB_TOKEN}"
GH_TAGS="$GH_REPO/releases/tags/$RELEASE"
payload=$(
  jq --null-input \
     --arg tag "$RELEASE" \
     --arg name "MEWconnect-iOS $RELEASE" \
     --arg body "$CHANGELOG" \
     '{ tag_name: $tag, name: $name, body: $body, draft: false }'
)

response=$(
  curl -H "$AUTH" \
        --fail \
        --silent \
        --location \
        --data "$payload" \
        "https://api.github.com/repos/${REPO}/releases"
)

upresponse=$(curl -sH "$AUTH" $GH_TAGS)
eval $(echo "$upresponse" | grep -m 1 "id.:" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
[ "$id" ] || { echo "Error: Failed to get release id for tag: $RELEASE"; echo "$upresponse" | awk 'length($0)<100' >&2; exit 1; }
