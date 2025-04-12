ARG BASE_TAG=bookworm
FROM debian:${BASE_TAG}

# Install common tools
RUN apt update && apt install -y \
    zsh \
    git \
    curl \
    wget \
    locales \
    procps \
    sudo \
    nano \
    less \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set locale (optional but useful)
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Add non-root user
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set Zsh as default shell for user
RUN chsh -s /bin/zsh $USERNAME

# Plugin install location
ENV ZSH_PLUGINS_DIR=/home/$USERNAME/.zsh_plugins

# Install plugins for the user
RUN mkdir -p $ZSH_PLUGINS_DIR && \
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS_DIR/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_PLUGINS_DIR/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-completions $ZSH_PLUGINS_DIR/zsh-completions && \
    chown -R $USERNAME:$USERNAME $ZSH_PLUGINS_DIR

# Create .zshrc
USER $USERNAME
RUN echo 'export HISTFILE=~/.zsh_history' >> ~/.zshrc && \
    echo 'export HISTSIZE=10000' >> ~/.zshrc && \
    echo 'export SAVEHIST=10000' >> ~/.zshrc && \
    echo 'setopt HIST_IGNORE_DUPS' >> ~/.zshrc && \
    echo 'setopt INC_APPEND_HISTORY' >> ~/.zshrc && \
    echo 'setopt SHARE_HISTORY' >> ~/.zshrc && \
    echo 'fpath+=($HOME/.zsh_plugins/zsh-completions/src)' >> ~/.zshrc && \
    echo 'autoload -Uz compinit && compinit' >> ~/.zshrc && \
    echo 'source $HOME/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc && \
    echo 'source $HOME/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc && \
    echo 'zstyle ":completion:*" menu select' >> ~/.zshrc && \
    echo 'zstyle ":completion:*" group-name ""' >> ~/.zshrc && \
    echo 'bindkey "^[[A" history-search-backward' >> ~/.zshrc && \
    echo 'bindkey "^[[B" history-search-forward' >> ~/.zshrc && \
    echo 'alias ll="ls -la"' >> ~/.zshrc

WORKDIR /home/$USERNAME
CMD ["zsh"]
