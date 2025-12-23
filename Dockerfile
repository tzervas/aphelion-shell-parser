FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt-get update && apt-get install -y \
    bash \
    git \
    curl \
    wget \
    jq \
    python3 \
    python3-pip \
    python3-venv \
    docker.io \
    shellcheck \
    bats \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip3 install poetry

# Create a test user
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /workspace

# Copy the parser files
COPY bash_prompt /home/testuser/bash_prompt
COPY .bashrc.example /home/testuser/.bashrc
COPY tests /workspace/tests

# Set proper permissions
RUN chown -R testuser:testuser /home/testuser && \
    chmod +x /home/testuser/bash_prompt/parsers/*.sh && \
    chmod +x /home/testuser/bash_prompt/prompt_generator.sh

# Switch to test user
USER testuser

# Set bash as default shell
SHELL ["/bin/bash", "-c"]

CMD ["/bin/bash"]
