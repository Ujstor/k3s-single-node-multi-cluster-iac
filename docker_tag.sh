#!/bin/bash
set -e

# Load configuration from yaml
eval $(yq e '.docker | to_entries | .[] | "export \(.key)=\(.value)"' docker-config.yml)

# Harbor authentication token
get_harbor_token() {
    local token_url="https://${HARBOR_URL}/service/token?service=harbor-registry&scope=repository:${HARBOR_PROJECT}/${HARBOR_REPO}:pull,push"
    local token_response=$(curl -s -u "${HARBOR_USERNAME}:${HARBOR_PASSWORD}" "$token_url")
    echo "$token_response" | jq -r '.token'
}

# Get tags from Harbor
get_harbor_tags() {
    local token=$1
    
    if [ -z "$token" ]; then
        echo "No token provided" >&2
        return 1
    fi

    # Direct tags endpoint
    local api_url="https://${HARBOR_URL}/v2/${HARBOR_PROJECT}/${HARBOR_REPO}/tags/list"
    local response=$(curl -s -H "Authorization: Bearer $token" "$api_url")
    local tags=$(echo "$response" | jq -r '.tags[]' 2>/dev/null)
    
    if [ -z "$tags" ]; then
        # Fallback to artifacts endpoint
        api_url="https://${HARBOR_URL}/api/v2.0/projects/${HARBOR_PROJECT}/repositories/${HARBOR_REPO}/artifacts"
        response=$(curl -s -H "Authorization: Bearer $token" "$api_url")
        tags=$(echo "$response" | jq -r '.[].tags[].name' 2>/dev/null)
    fi
    
    echo "$tags"
}

# Main execution
main() {
    TOKEN=$(get_harbor_token)
    
    if [ -z "$TOKEN" ]; then
        echo "Failed to get valid token"
        exit 1
    fi
    
    TAGS=$(get_harbor_tags "$TOKEN")
    
    if [ -z "$TAGS" ]; then
        DEFAULT_TAG="0.0.1"
        NEW_TAG="$DEFAULT_TAG"
    else
        LATEST_TAG=0.0.1  # We know this exists
        
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
    
    create_env_file
}

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

main
