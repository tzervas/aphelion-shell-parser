#!/bin/bash

# Function to get the default project name based on the directory name
get_default_project_name() {
    basename "$(pwd)"
}

# Function to extract project name from pyproject.toml
get_poetry_project_name() {
    local poetry_project_name=$(awk -F '"' '/^name = /{print $2; exit}' pyproject.toml)
    echo "$poetry_project_name"
}

# Function to extract project version from pyproject.toml
get_poetry_project_version() {
    local poetry_project_version=$(awk -F '"' '/^version = /{print $2; exit}' pyproject.toml)
    echo "$poetry_project_version"
}

# Function to extract project name from poetry.lock
get_poetry_lock_project_name() {
    local poetry_lock_project_name=$(awk '/^name /{print $3; exit}' poetry.lock | tr -d '"')
    echo "$poetry_lock_project_name"
}

# Function to count dependencies in requirements.txt
count_requirements_dependencies() {
    local requirements_count=$(grep -c '^[^#]' requirements.txt)  # Count non-comment lines
    echo "$requirements_count"
}

# Function to extract project name from requirements.txt
get_requirements_project_name() {
    local reqs_project_name=$(awk '/^# *project *:/{gsub(/^# *project *: */, ""); print; exit}' requirements.txt)
    echo "$reqs_project_name"
}

# Main function to combine all the logic and provide project info
parse_python_project() {
    local project_info=""

    # Check if any Python project files exist before gathering info
    if [ ! -f "pyproject.toml" ] && [ ! -f "poetry.lock" ] && [ ! -f "requirements.txt" ] && \
       [ ! -f "setup.py" ] && [ ! -f "setup.cfg" ] && [ ! -f "Pipfile" ]; then
        return
    fi

    # Get the default project name based on the directory name
    local project_name
    project_name=$(get_default_project_name)

    # Check for Poetry managed project (pyproject.toml)
    if [ -f "pyproject.toml" ]; then
        local poetry_project_name
        local poetry_project_version
        poetry_project_name=$(get_poetry_project_name)
        poetry_project_version=$(get_poetry_project_version)
        project_info="Poetry|${poetry_project_name:-$project_name} v${poetry_project_version}"
    elif [ -f "poetry.lock" ]; then
        # Fallback to details from poetry.lock
        local poetry_lock_project_name
        poetry_lock_project_name=$(get_poetry_lock_project_name)
        project_name="${poetry_lock_project_name:-$project_name}"
        project_info="Poetry|${project_name}"
    fi

    # If neither pyproject.toml nor poetry.lock is available
    if [ -z "$project_info" ]; then
        # Check for Pipfile (Pipenv)
        if [ -f "Pipfile" ]; then
            project_info="Pipenv|${project_name}"
        # Check for setup.py or setup.cfg (setuptools)
        elif [ -f "setup.py" ] || [ -f "setup.cfg" ]; then
            project_info="setuptools|${project_name}"
        # Check for requirements.txt and count dependencies
        elif [ -f "requirements.txt" ]; then
            local requirements_count
            local reqs_project_name
            requirements_count=$(count_requirements_dependencies)
            reqs_project_name=$(get_requirements_project_name)
            project_name="${reqs_project_name:-$project_name}"
            project_info="proj:($project_name|deps:$requirements_count)"
        fi
    fi

    echo "$project_info"
}
