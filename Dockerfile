# Use Debian slim for a small base image
FROM debian:bookworm-slim

# Install minimal dependencies (curl for downloading Neovim)
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Download the latest Neovim AppImage, extract it, and install runtime files
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage && \
    chmod +x nvim-linux-x86_64.appimage && \
    ./nvim-linux-x86_64.appimage --appimage-extract && \
    mv squashfs-root/usr/bin/nvim /usr/local/bin/nvim && \
    mkdir -p /usr/local/share/nvim && \
    mv squashfs-root/usr/share/nvim/runtime /usr/local/share/nvim/ && \
    rm -rf squashfs-root nvim-linux-x86_64.appimage

# Create a home directory for the user
RUN mkdir -p /home/user/.local/state/nvim && \
    chmod -R 777 /home/user  # Temporary permissive permissions for flexibility

# Set the working directory to /workspace
WORKDIR /workspace

# Set HOME environment variable and launch Neovim
ENV HOME=/home/user
ENTRYPOINT ["/usr/local/bin/nvim"]
CMD []