#!/bin/bash

parse_docker_info() {
    local parser_type="Docker"

    if type docker >/dev/null 2>&1; then
        local running_containers=$(docker ps -q | wc -l)

        if [ -n "$running_containers" ]; then
            echo "${parser_type}:${running_containers} running"
        else
            echo "${parser_type}: No Info"
        fi
    else
        echo "${parser_type}: Not Installed"
    fi
}

# Call the function
parse_docker_info
