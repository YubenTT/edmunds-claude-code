#!/bin/bash
# AI CLI Orchestrator V2 - Bash Client Example
#
# Simple bash script for interacting with the AI CLI Orchestrator V2 API.

# Configuration
API_URL="${AI_API_URL:-http://localhost:3001/api/v1}"
API_KEY="${AI_API_KEY:-your-api-key-here}"

# Helper function to make API calls
api_call() {
    local method=$1
    local endpoint=$2
    local data=$3

    if [ "$method" = "POST" ]; then
        curl -s -X POST "$API_URL$endpoint" \
            -H "Authorization: Bearer $API_KEY" \
            -H "Content-Type: application/json" \
            -d "$data"
    else
        curl -s -X GET "$API_URL$endpoint" \
            -H "Authorization: Bearer $API_KEY"
    fi
}

# Submit a chat request
chat_async() {
    local prompt=$1
    local provider=${2:-auto}
    local priority=${3:-normal}

    local request_data=$(cat <<EOF
{
  "prompt": "$prompt",
  "provider": "$provider",
  "priority": "$priority"
}
EOF
)

    local response=$(api_call "POST" "/chat" "$request_data")
    echo "$response" | jq -r '.id'
}

# Get request status
get_status() {
    local request_id=$1
    api_call "GET" "/status/$request_id"
}

# Wait for request to complete
wait_for_completion() {
    local request_id=$1
    local max_wait=${2:-120}
    local poll_interval=${3:-1}

    local start_time=$(date +%s)

    while true; do
        local status=$(get_status "$request_id")
        local state=$(echo "$status" | jq -r '.status')

        if [ "$state" = "completed" ]; then
            echo "$status"
            return 0
        fi

        if [ "$state" = "failed" ]; then
            echo "ERROR: Request failed" >&2
            echo "$status" | jq -r '.error_message' >&2
            return 1
        fi

        local elapsed=$(($(date +%s) - start_time))
        if [ $elapsed -gt $max_wait ]; then
            echo "ERROR: Request timed out after $max_wait seconds" >&2
            return 1
        fi

        sleep $poll_interval
    done
}

# Send chat request and wait for response
chat() {
    local prompt=$1
    local provider=${2:-auto}

    echo "Sending request..." >&2
    local request_id=$(chat_async "$prompt" "$provider")

    echo "Request ID: $request_id" >&2
    echo "Waiting for response..." >&2

    local result=$(wait_for_completion "$request_id")
    echo "$result" | jq -r '.response'
}

# Get quotas
get_quotas() {
    api_call "GET" "/quotas"
}

# Display quota summary
show_quotas() {
    local quotas=$(get_quotas)

    echo "Current Quota Usage:"
    echo "===================="

    echo "$quotas" | jq -r '.providers | to_entries[] | "\(.key): \(.value.daily.used)/\(.value.daily.limit) used (\(.value.daily.remaining) remaining)"'

    echo ""
    echo "Total Accounts: $(echo "$quotas" | jq -r '.total_accounts')"
    echo "Active Accounts: $(echo "$quotas" | jq -r '.active_accounts')"
}

# Main function
main() {
    case "${1:-help}" in
        chat)
            if [ -z "$2" ]; then
                echo "Usage: $0 chat \"your prompt\" [provider]"
                exit 1
            fi
            chat "$2" "${3:-auto}"
            ;;

        status)
            if [ -z "$2" ]; then
                echo "Usage: $0 status REQUEST_ID"
                exit 1
            fi
            get_status "$2" | jq '.'
            ;;

        quotas)
            show_quotas
            ;;

        help|*)
            cat <<EOF
AI CLI Orchestrator V2 - Bash Client

Usage:
  $0 chat "your prompt" [provider]     Send a chat request
  $0 status REQUEST_ID                  Get request status
  $0 quotas                             Show quota usage

Environment Variables:
  AI_API_URL    API base URL (default: http://localhost:3001/api/v1)
  AI_API_KEY    Your API key (required)

Examples:
  export AI_API_KEY="sk_live_abc123..."

  # Simple chat
  $0 chat "What is recursion?"

  # Use specific provider
  $0 chat "Explain AI" chatgpt

  # Check quotas
  $0 quotas

  # Get request status
  $0 status req_abc123
EOF
            ;;
    esac
}

# Run main function
main "$@"
