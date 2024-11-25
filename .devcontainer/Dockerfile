FROM mcr.microsoft.com/devcontainers/base:debian

# Install needed packages
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    zsh \
    btop    

RUN chsh -s /bin/zsh vscode
USER vscode

# Copy zshrc
COPY --chown=vscode:vscode .zshrc /home/vscode/.zshrc