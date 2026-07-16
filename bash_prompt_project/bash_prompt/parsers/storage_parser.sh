#!/bin/bash

calculate_storage_used() {
    local parser_type="Storage"

    # Get the storage size
    local size=$(du -sh 2> /dev/null | cut -f1)

    if [ -n "$size" ]; then
        echo "${parser_type}:${size}"
    else
        echo "${parser_type}: No Info"
    fi
}

# Call the function
calculate_storage_used
