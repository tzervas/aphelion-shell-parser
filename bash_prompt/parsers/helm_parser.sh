#!/bin/bash

parse_helm_info() {
    local parser_type="Helm"

    # Check if helm is installed
    if ! type helm >/dev/null 2>&1; then
        return
    fi

    local deployed_charts=$(helm list --deployed -q 2>/dev/null | wc -l)

    if [ -n "$deployed_charts" ] && [ "$deployed_charts" -gt 0 ]; then
        echo "${parser_type}:${deployed_charts} deployed"
    fi
}
