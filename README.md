# Aphelion Parser

<!-- FLEET-BADGES:BEGIN -->
[![CI](https://github.com/tzervas/aphelion-shell-parser/actions/workflows/fleet-ci.yml/badge.svg?branch=main)](https://github.com/tzervas/aphelion-shell-parser/actions/workflows/fleet-ci.yml?query=branch%3Amain)
[![Security](https://github.com/tzervas/aphelion-shell-parser/actions/workflows/fleet-security.yml/badge.svg?branch=main)](https://github.com/tzervas/aphelion-shell-parser/actions/workflows/fleet-security.yml?query=branch%3Amain)
<!-- FLEET-BADGES:END -->

Aphelion Git Parser is a bash script that enhances your terminal prompt by displaying Git repository and Python virtual environment information. It automatically detects if the current directory is a Git repository and shows the repository name, current branch, and status when you're inside a Git repository. It also supports showing the active Python virtual environment.

## Overview

The bashrc project is designed to enhance the interactive shell experience by providing a customized and feature-rich Bash environment. This project integrates various tools such as AWS CLI, kubectl, Docker, Helm, Terraform, and Git, making it ideal for developers, especially those working in DevOps and cloud environments.

## Features

Customized Bash Prompt: Enhanced prompt for better visibility and information display.
Integration with Cloud Tools: Easy access to AWS CLI, Kubernetes, and Terraform.
Developer Tools: Pre-configured Git, Docker, and Helm for seamless development workflows.
Enhanced Editor Support: Included configurations for Vim and Nano.
Python Environment Management: Support for Python virtual environments.

## Prerequisites

- AWS CLI
- Docker
- Git
- Helm
- Kubernetes
- Terraform
- python 3.8+
- python3-venv

### Installing Prerequisites

The following guidance is based on the assumption this will be installed on a Ubuntu 23.10 (Mantic) host.

```bash
# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install

# Install kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y terraform
```

## Installation

Clone the repo, then backup your current `
.bashrc`. Next copy the contents of the `bash_prompt_project`
directory to your home directory and source the new `.bashrc`

## Usage

Once the Docker container is up and running, you will be dropped into the customized Bash shell. Here, you can use the integrated tools and enjoy the enhanced shell experience.

## Customization

Bash Prompt: Edit the .bashrc file to modify the prompt.
Tool Configurations: Modify respective configuration files (like .vimrc or .nanorc) for editor customizations.
Contributing
Contributions to the bashrc project are welcome. Please submit pull requests or issues to the project repository.

## License

MIT
