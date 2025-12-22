#!/bin/bash

parse_terraform_info() {
    local parser_type="TF"

    # Check if .terraform directory exists
    if [ ! -d ".terraform" ]; then
        return
    fi

    # Check if terraform is installed
    if ! type terraform >/dev/null 2>&1; then
        return
    fi

    local workspace=$(terraform workspace show 2>/dev/null)

    if [ -n "$workspace" ]; then
        echo "${parser_type}:${workspace}"
    fi
}
