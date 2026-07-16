#!/bin/bash

# Prompt generator script for an enhanced shell prompt

# Custom Prompt Generation Function.
generate_prompt() {
    # Source the parser functions script.
    for script in ~/bash_prompt/parsers/*.sh; do
        source "$script"
    done

    # Combine all tool info.
    local git_info=$(parse_git_info)
    local python_project_info=$(parse_python_project)
    local venv_info=$(parse_virtual_env)
    local docker_info=$(parse_docker_info)
    local k8s_info=$(parse_kubectl_info)
    local helm_info=$(parse_helm_info)
    local aws_info=$(parse_cloudformation_info)
    local tf_info=$(parse_terraform_info)
    # ... [Other parser function calls]

    # Create an array to hold information lines.
    local info_lines=()

    # Add default information line.
    local default_info="\u@\h:\w"

    # Check if any parser has information to display.
    if [ -n "$git_info" ] || [ -n "$python_project_info" ] || [ -n "$venv_info" ] || [ -n "$docker_info" ] || [ -n "$k8s_info" ] || [ -n "$helm_info" ] || [ -n "$aws_info" ] || [ -n "$tf_info" ] || [ -n "... other checks ..." ]; then
        info_lines+=("$default_info")
    fi

    # Group 1: Git, Python Project, and Virtual Environment Info
    local group1=""
    if [ -n "$git_info" ]; then
        group1+="Git: $git_info  "
    fi
    if [ -n "$python_project_info" ]; then
        group1+="Python: $python_project_info  "
    fi
    if [ -n "$venv_info" ]; then
        group1+="Venv: $venv_info"
    fi
    info_lines+=("$group1")

    # Group 2: Docker, Kubernetes, and Helm Info
    local group2=""
    if [ -n "$docker_info" ]; then
        group2+="Docker: $docker_info  "
    fi
    if [ -n "$k8s_info" ]; then
        group2+="K8s: $k8s_info  "
    fi
    if [ -n "$helm_info" ]; then
        group2+="Helm: $helm_info"
    fi
    info_lines+=("$group2")

    # Group 3: AWS, Terraform, and CloudFormation Info
    local group3=""
    if [ -n "$aws_info" ]; then
        group3+="AWS: $aws_info  "
    fi
    if [ -n "$tf_info" ]; then
        group3+="TF: $tf_info"
    fi
    info_lines+=("$group3")

    # ... [Add more groups based on logical grouping]

    # Create the information block by joining lines with newlines.
    local info_block=""
    if [ "${#info_lines[@]}" -gt 0 ]; then
        info_block="\n${info_lines[@]}"
    fi

    # Apply color only if supported, else use non-colorized format.
    if [ "$color_prompt" ]; then
        PS1="${debian_chroot:+($debian_chroot)}${info_block}\n\[\e[1m\]Δ\[\e[0m\] "
    else
        PS1="${debian_chroot:+($debian_chroot)}${info_block}\n\[\e[1m\]Δ\[\e[0m\] "
    fi
}
