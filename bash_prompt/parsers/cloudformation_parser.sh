#!/bin/bash

parse_cloudformation_info() {
    local parser_type="CFN"

    # Check if AWS CLI is installed
    if ! type aws >/dev/null 2>&1; then
        return
    fi

    # Check if jq is installed for JSON parsing
    if ! type jq >/dev/null 2>&1; then
        return
    fi

    # Check if AWS credentials are configured
    if ! aws sts get-caller-identity >/dev/null 2>&1; then
        return
    fi

    local active_stacks=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE 2>/dev/null | jq '.StackSummaries | length' 2>/dev/null)

    if [ -n "$active_stacks" ] && [ "$active_stacks" -gt 0 ]; then
        echo "${parser_type}:${active_stacks} active stacks"
    fi
}
