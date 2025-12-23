#!/bin/bash

parse_docker_info() {
    local parser_type="Docker"

    # Check if docker is installed and accessible
    if ! type docker >/dev/null 2>&1; then
        return
    fi

    # Check if docker daemon is running (suppress permission errors)
    if ! docker info >/dev/null 2>&1; then
        return
    fi

    local running_containers=$(docker ps -q 2>/dev/null | wc -l)

    if [ -n "$running_containers" ] && [ "$running_containers" -gt 0 ]; then
        echo "${parser_type}:${running_containers} running"
    fi
}
