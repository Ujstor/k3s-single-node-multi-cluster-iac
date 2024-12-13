#!/bin/bash

# Load configuration from yaml
eval $(yq e '.docker | to_entries | .[] | "export \(.key)=\(.value)"' docker-config.yml)


#  Harbor authentication token
get_harbor_token() {
    local token=$(curl -s -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" \
        "https://${HARBOR_URL}/service/token?service=harbor-registry&scope=repository:${HARBOR_PROJECT}/${HARBOR_REPO}:pull")
    echo $(echo $token | jq -r '.token')
}

# Get tags from Harbor
get_harbor_tags() {
    local token=$(get_harbor_token)
    local tags=$(curl -s -H "Authorization: Bearer $token" \
        "https://${HARBOR_URL}/api/v2.0/projects/${HARBOR_PROJECT}/repositories/${HARBOR_REPO}/artifacts" | \
        jq -r '.[].tags[].name' 2>/dev/null)
    echo "$tags"
}

# Get tags and process version
TAGS=$(get_harbor_tags)
if [ -z "$TAGS" ]; then
    DEFAULT_TAG="0.0.1"
    NEW_TAG="$DEFAULT_TAG"
else
    LATEST_TAG=$(echo "$TAGS" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1)
    if [ -z "$LATEST_TAG" ]; then
        LATEST_TAG="0.0.1"
    fi
    IFS='.' read -ra PARTS <<< "$LATEST_TAG"
    MAJOR=${PARTS[0]}
    MINOR=${PARTS[1]}
    PATCH=${PARTS[2]}

    if [[ "$VERSION_PART" == "Major" ]]; then
        NEW_TAG="$((MAJOR + 1)).0.0"
    elif [[ "$VERSION_PART" == "Minor" ]]; then
        NEW_TAG="$MAJOR.$((MINOR + 1)).0"
    elif [[ "$VERSION_PART" == "Patch" ]]; then
        NEW_TAG="$MAJOR.$MINOR.$((PATCH + 1))"
    else
        echo "Invalid version part specified. Usage: $0 [Major|Minor|Patch]"
        exit 1
    fi
fi

# Create .env file
create_env_file() {
    cat << EOF > .env
HARBOR_URL=$HARBOR_URL
HARBOR_PROJECT=$HARBOR_PROJECT
HARBOR_REPO=$HARBOR_REPO
NEW_TAG=$NEW_TAG
PUSH_TO_HARBOR=$PUSH_TO_HARBOR
EOF
}

create_env_file
