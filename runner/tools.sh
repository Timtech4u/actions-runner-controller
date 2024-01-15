#!/bin/bash


# GitHub CLI
if grep -q "Ubuntu\|Debian" "/etc/os-release"; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  apt-get install dirmngr -y
  apt-get update
  apt-get install gh -y
  apt-get autoclean
  apt-get autoremove
  rm -rf /var/lib/apt/lists/*
elif grep -q "CentOS\|Red Hat" "/etc/redhat-release"; then
  yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  yum install -y gh
  yum clean all
fi


# Kubectl
# Download
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Validate
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check | grep -q "kubectl: OK"

# Install
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Node
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install nodejs -y
apt-get autoclean
apt-get autoremove

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip ./aws

# Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install terraform

# Kind
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.11.1/kind-$(uname -m)" \
    && chmod +x ./kind \
    && mv ./kind /usr/local/bin/kind