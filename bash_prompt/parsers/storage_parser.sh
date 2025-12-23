#!/bin/bash

calculate_storage_used() {
    local target_path="${1:-.}"
    
    # Get the storage size for the given path
    local size=$(du -sh "$target_path" 2>/dev/null | cut -f1)

    if [ -n "$size" ]; then
        echo "$size"
    fi
}
