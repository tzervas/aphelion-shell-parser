#!/bin/bash

parse_virtual_env() {
    local parser_type="Venv"

    if [ -n "$VIRTUAL_ENV" ]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        local venv_size=$(calculate_storage_used "$VIRTUAL_ENV")  # Assuming calculate_storage_used is available

        if [ -n "$venv_name" ] || [ -n "$venv_size" ]; then
            echo "${parser_type}:${venv_name:-No Name}|${venv_size:-No Size}"
        else
            echo "${parser_type}: No Info"
        fi
    else
        echo "${parser_type}: Not Active"
    fi
}

# Call the function
parse_virtual_env
