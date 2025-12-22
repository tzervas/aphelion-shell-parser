#!/bin/bash

# Prompt generator script for an enhanced shell prompt

# Custom Prompt Generation Function.
generate_prompt() {
    # Determine parser directory location
    local parser_dir="${APHELION_PARSER_DIR:-$HOME/bash_prompt/parsers}"
    
    # Source the parser functions script if they exist
    if [ -d "$parser_dir" ]; then
        for script in "$parser_dir"/*.sh; do
            if [ -f "$script" ]; then
                source "$script"
            fi
        done
    fi

    # Combine all tool info (only call if functions are defined)
    local git_info=""
    local python_project_info=""
    local venv_info=""
    local docker_info=""
    local k8s_info=""
    local helm_info=""
    local aws_info=""
    local tf_info=""
    
    type parse_git_info >/dev/null 2>&1 && git_info=$(parse_git_info)
    type parse_python_project >/dev/null 2>&1 && python_project_info=$(parse_python_project)
    type parse_virtual_env >/dev/null 2>&1 && venv_info=$(parse_virtual_env)
    type parse_docker_info >/dev/null 2>&1 && docker_info=$(parse_docker_info)
    type parse_kubectl_info >/dev/null 2>&1 && k8s_info=$(parse_kubectl_info)
    type parse_helm_info >/dev/null 2>&1 && helm_info=$(parse_helm_info)
    type parse_cloudformation_info >/dev/null 2>&1 && aws_info=$(parse_cloudformation_info)
    type parse_terraform_info >/dev/null 2>&1 && tf_info=$(parse_terraform_info)

    # Create an array to hold information lines.
    local info_lines=()

    # Add default information line.
    local default_info="\u@\h:\w"

    # Check if any parser has information to display.
    if [ -n "$git_info" ] || [ -n "$python_project_info" ] || [ -n "$venv_info" ] || [ -n "$docker_info" ] || [ -n "$k8s_info" ] || [ -n "$helm_info" ] || [ -n "$aws_info" ] || [ -n "$tf_info" ]; then
        info_lines+=("$default_info")
    fi

    # Group 1: Git, Python Project, and Virtual Environment Info
    local group1=""
    if [ -n "$git_info" ]; then
        group1+="$git_info  "
    fi
    if [ -n "$python_project_info" ]; then
        group1+="Python: $python_project_info  "
    fi
    if [ -n "$venv_info" ]; then
        group1+="$venv_info"
    fi
    if [ -n "$group1" ]; then
        info_lines+=("$group1")
    fi

    # Group 2: Docker, Kubernetes, and Helm Info
    local group2=""
    if [ -n "$docker_info" ]; then
        group2+="$docker_info  "
    fi
    if [ -n "$k8s_info" ]; then
        group2+="$k8s_info  "
    fi
    if [ -n "$helm_info" ]; then
        group2+="$helm_info"
    fi
    if [ -n "$group2" ]; then
        info_lines+=("$group2")
    fi

    # Group 3: AWS, Terraform, and CloudFormation Info
    local group3=""
    if [ -n "$aws_info" ]; then
        group3+="$aws_info  "
    fi
    if [ -n "$tf_info" ]; then
        group3+="$tf_info"
    fi
    if [ -n "$group3" ]; then
        info_lines+=("$group3")
    fi

    # Create the information block by joining lines with newlines.
    local info_block=""
    if [ "${#info_lines[@]}" -gt 0 ]; then
        # Join array elements with newline
        printf -v info_block '\n%s' "${info_lines[@]}"
    fi

    # Apply color only if supported, else use non-colorized format.
    if [ "$color_prompt" ]; then
        PS1="${debian_chroot:+($debian_chroot)}${info_block}\n\[\e[1m\]Δ\[\e[0m\] "
    else
        PS1="${debian_chroot:+($debian_chroot)}${info_block}\n\[\e[1m\]Δ\[\e[0m\] "
    fi
}
