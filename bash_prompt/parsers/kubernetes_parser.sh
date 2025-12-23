#!/bin/bash

parse_kubectl_info() {
    local parser_type="K8s"

    # Check if kubectl is installed
    if ! type kubectl >/dev/null 2>&1; then
        return
    fi

    local context=$(kubectl config current-context 2>/dev/null)

    if [ -n "$context" ]; then
        echo "${parser_type}:${context}"
    fi
}
