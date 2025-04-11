FROM debian:bookworm-slim

# Define build arguments for host UID, GID, username, and group name
ARG HOST_UID
ARG HOST_GID
ARG HOST_USER
ARG HOST_GROUP

# Install minimal dependencies for Neovim and LunarVim, including bash
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates git make python3 python3-pip python3-dev \
    nodejs npm cargo bash && \
    rm -rf /var/lib/apt/lists/*

# Create a group and user with the same UID, GID, username, and group name as the host
RUN groupadd -g ${HOST_GID} ${HOST_GROUP} && \
    useradd -u ${HOST_UID} -g ${HOST_GID} -m -s /bin/bash ${HOST_USER}

# Install rustup and the latest stable Rust toolchain for the host user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | su - ${HOST_USER} -c "sh -s -- -y" && \
    su - ${HOST_USER} -c "/home/${HOST_USER}/.cargo/bin/rustup update stable" && \
    su - ${HOST_USER} -c "/home/${HOST_USER}/.cargo/bin/rustup default stable"

# Download and extract the latest Neovim AppImage
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage && \
    chmod +x nvim-linux-x86_64.appimage && \
    ./nvim-linux-x86_64.appimage --appimage-extract && \
    mv squashfs-root/usr/bin/nvim /usr/local/bin/nvim && \
    mkdir -p /usr/local/share/nvim && \
    mv squashfs-root/usr/share/nvim/runtime /usr/local/share/nvim/ && \
    rm -rf squashfs-root nvim-linux-x86_64.appimage

# Install LunarVim as the host user
RUN su - ${HOST_USER} -c "bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y" && \
    mv /home/${HOST_USER}/.local/bin/lvim /usr/local/bin/lvim && \
    chmod +x /usr/local/bin/lvim

# Set the working directory to /workspace
WORKDIR /workspace

# Set HOME environment variable dynamically
ENV HOME=/home/${HOST_USER}

# Set LunarVim as the entrypoint
ENTRYPOINT ["/usr/local/bin/lvim"]
CMD []
