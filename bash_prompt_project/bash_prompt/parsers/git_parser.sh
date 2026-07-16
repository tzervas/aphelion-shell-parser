#!/bin/bash

parse_git_info() {
    local parser_type="Git"

    # Get the current Git branch
    local branch=$(git branch 2> /dev/null | grep '*' | sed 's/* //')

    # Get the Git status (abbreviated)
    local status=$(git status -s 2> /dev/null | awk '{print $1}' | uniq | xargs)

    # Get the last commit hash (abbreviated)
    local last_commit=$(git log -1 --pretty=format:"%h" 2> /dev/null)

    # Check if Git is installed
    if type git >/dev/null 2>&1; then
        if [ -n "$branch" ] || [ -n "$status" ] || [ -n "$last_commit" ]; then
            echo "${parser_type}:(${branch:-No Branch}|${status:-Clean}|${last_commit:-No Commit})"
        else
            echo "${parser_type}: No Info"
        fi
    else
        echo "${parser_type}: Not Installed"
    fi
}

# Call the function
parse_git_info
