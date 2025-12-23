#!/bin/bash

# Helper function to calculate storage size (matches storage_parser.sh naming)
calculate_storage_used() {
    local target_path="${1:-.}"
    
    if [ -d "$target_path" ]; then
        du -sh "$target_path" 2>/dev/null | cut -f1
    fi
}

parse_virtual_env() {
    local parser_type="Venv"

    if [ -n "$VIRTUAL_ENV" ]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        local venv_size=$(calculate_storage_used "$VIRTUAL_ENV")

        if [ -n "$venv_name" ]; then
            echo "${parser_type}:${venv_name}|${venv_size:-N/A}"
        fi
    fi
}
