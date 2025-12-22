#!/bin/bash

parse_kubectl_info() {
    local parser_type="K8s"

    if type kubectl >/dev/null 2>&1; then
        local context=$(kubectl config current-context 2>/dev/null)

        if [ -n "$context" ]; then
            echo "${parser_type}:${context}"
        else
            echo "${parser_type}: No Info"
        fi
    else
        echo "${parser_type}: Not Installed"
    fi
}

# Call the function
parse_kubectl_info
