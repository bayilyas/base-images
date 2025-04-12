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

# Set zsh as default shell
SHELL ["/bin/zsh", "-c"]
RUN chsh -s $(which zsh)

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Add plugins (zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting)
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# Create .zshrc
USER $USERNAME

RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' ~/.zshrc && \
    echo 'export HISTFILE=~/.zsh_history' >> ~/.zshrc && \
    echo 'export HISTSIZE=10000' >> ~/.zshrc && \
    echo 'export SAVEHIST=10000' >> ~/.zshrc && \
    echo 'setopt inc_append_history share_history' >> ~/.zshrc && \
    echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

# Start zsh by default
WORKDIR /home/$USERNAME
CMD ["zsh"]
