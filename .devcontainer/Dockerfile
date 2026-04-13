FROM mcr.microsoft.com/devcontainers/base:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    jq \
    zsh \
  && rm -rf /var/lib/apt/lists/*

USER vscode
