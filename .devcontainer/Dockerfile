FROM mcr.microsoft.com/devcontainers/base:debian

# Install needed packages
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    zsh \
    btop    

RUN chsh -s /bin/zsh vscode
USER vscode

# Add oh-my-zsh
RUN rm -rf /home/vscode/.oh-my-zsh && \
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Copy zshrc
COPY --chown=vscode:vscode .zshrc /home/vscode/.zshrc