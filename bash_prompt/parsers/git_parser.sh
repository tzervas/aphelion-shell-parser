#!/bin/bash

parse_git_info() {
    local parser_type="Git"

    # Check if Git is installed
    if ! type git >/dev/null 2>&1; then
        return
    fi

    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        return
    fi

    # Get the current Git branch
    local branch=$(git branch 2> /dev/null | grep '*' | sed 's/* //')

    # Get the Git status (abbreviated)
    local status=$(git status -s 2> /dev/null | awk '{print $1}' | uniq | xargs)

    # Get the last commit hash (abbreviated)
    local last_commit=$(git log -1 --pretty=format:"%h" 2> /dev/null)

    # Only output if we're in a git repository
    if [ -n "$branch" ] || [ -n "$status" ] || [ -n "$last_commit" ]; then
        echo "${parser_type}:(${branch:-No Branch}|${status:-Clean}|${last_commit:-No Commit})"
    fi
}
