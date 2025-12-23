#!/bin/bash

parse_helm_info() {
    local parser_type="Helm"

    if type helm >/dev/null 2>&1; then
        local deployed_charts=$(helm list --deployed -q | wc -l)

        if [ -n "$deployed_charts" ]; then
            echo "${parser_type}:${deployed_charts} deployed"
        else
            echo "${parser_type}: No Info"
        fi
    else
        echo "${parser_type}: Not Installed"
    fi
}

# Call the function
parse_helm_info
