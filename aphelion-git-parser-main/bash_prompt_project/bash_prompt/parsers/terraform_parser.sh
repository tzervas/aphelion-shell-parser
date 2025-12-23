#!/bin/bash

parse_terraform_info() {
    local parser_type="TF"

    if [ -d ".terraform" ]; then
        local workspace=$(terraform workspace show 2>/dev/null)

        if [ -n "$workspace" ]; then
            echo "${parser_type}:${workspace}"
        else
            echo "${parser_type}: No Info"
        fi
    else
        echo "${parser_type}: Not Configured"
    fi
}

# Call the function
parse_terraform_info
