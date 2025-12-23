#!/bin/bash

parse_cloudformation_info() {
    local parser_type="CFN"

    if type aws >/dev/null 2>&1; then
        local active_stacks=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE | jq '.StackSummaries | length')

        if [ -n "$active_stacks" ]; then
            echo "${parser_type}:${active_stacks} active stacks"
        else
            echo "${parser_type}: No Info"
        fi
    else
        echo "${parser_type}: Not Installed"
    fi
}

# Call the function
parse_cloudformation_info
