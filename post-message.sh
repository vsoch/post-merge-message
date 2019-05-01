#!/bin/bash

set -e
set -o pipefail

# Message is required to be defined
if [[ -z "$POST_MESSAGE" ]]; then
    echo "Please set the POST_MESSAGE environment variable."
    echo "This can be a path to a file, or text for the message itself."
    exit 1
fi

# GitHub token is required
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Please set the GITHUB_TOKEN environment variable."
    exit 1
fi

BASE=https://api.github.com
API_VERSION=v3

# URLs
REPO_URL="${BASE}/repos/${GITHUB_REPOSITORY}"

check_events_json() {

    if [[ ! -f "${GITHUB_EVENT_PATH}" ]]; then
        echo "Cannot find Github events file at ${GITHUB_EVENT_PATH}";
        exit 1;
    fi
    echo "Found ${GITHUB_EVENT_PATH}";

}


main() {

    # path to file that contains the POST response of the event
    # Example: https://github.com/actions/bin/tree/master/debug
    # Value: /github/workflow/event.json
    check_events_json;

    # Determine if we have merged, and the PR is closed
    ACTION=$(jq --raw-output .action "${GITHUB_EVENT_PATH}");
    MERGED=$(jq --raw-output .pull_request.merged "$GITHUB_EVENT_PATH")

    NUMBER=$(jq --raw-output .number "${GITHUB_EVENT_PATH}");
    COMMENTS_URL="${REPO_URL}/issues/${NUMBER}/comments"

    echo "[action:$ACTION][merged:$MERGED]"

    if [[ "$ACTION" == "closed" ]] && [[ "$MERGED" == "true" ]]; then

        ref=$(jq --raw-output .pull_request.head.ref "$GITHUB_EVENT_PATH")
        owner=$(jq --raw-output .pull_request.head.repo.owner.login "$GITHUB_EVENT_PATH")
        repo=$(jq --raw-output .pull_request.head.repo.name "$GITHUB_EVENT_PATH")

        # If the POST_MESSAGE is a file, read it in
        if [ -f "${POST_MESSAGE}" ]; then
            echo "Found file with message, ${POST_MESSAGE}"
        fi

        # Feeling lazy, do it with Python
        export COMMENTS_URL API_VERSION GITHUB_TOKEN POST_MESSAGE
        python3 /post_message.py
        retval=$?
        echo "Return value ${retval}"
        exit ${retval}
    fi
}

echo "==========================================================================
START: Running Post Merge Message Action!";
main "${@}";
echo "==========================================================================
END: Running Post Merge Message Action";
