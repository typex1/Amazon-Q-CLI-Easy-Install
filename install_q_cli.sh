#!/bin/bash

# Amazon Q CLI Easy Installer
# This script automates the installation of Amazon Q CLI based on your system architecture and glibc version

echo "=== Amazon Q CLI Easy Installer ==="
echo "Checking your system configuration..."

# Check system architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" && "$ARCH" != "aarch64" ]]; then
    echo "Error: Unsupported architecture: $ARCH"
    echo "Amazon Q CLI is only supported on x86_64 and aarch64 architectures."
    exit 1
fi
echo "Architecture detected: $ARCH"

# Check glibc version
echo "Checking glibc version..."
GLIBC_VERSION=$(ldd --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
GLIBC_MAJOR=$(echo $GLIBC_VERSION | cut -d. -f1)
GLIBC_MINOR=$(echo $GLIBC_VERSION | cut -d. -f2)

echo "glibc version detected: $GLIBC_VERSION"

# Determine if we need musl version
USE_MUSL=false
if (( GLIBC_MAJOR < 2 || (GLIBC_MAJOR == 2 && GLIBC_MINOR < 34) )); then
    USE_MUSL=true
    echo "Your system has glibc $GLIBC_VERSION, which is older than 2.34."
    echo "Will download the musl version of Amazon Q CLI."
else
    echo "Your system has glibc $GLIBC_VERSION, which is 2.34 or newer."
    echo "Will download the standard version of Amazon Q CLI."
fi

# Set download URL based on architecture and glibc version
if [[ "$ARCH" == "x86_64" ]]; then
    if [[ "$USE_MUSL" == "true" ]]; then
        DOWNLOAD_URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/q-x86_64-linux-musl.zip"
    else
        DOWNLOAD_URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/q-x86_64-linux.zip"
    fi
else # aarch64
    if [[ "$USE_MUSL" == "true" ]]; then
        DOWNLOAD_URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/q-aarch64-linux-musl.zip"
    else
        DOWNLOAD_URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/q-aarch64-linux.zip"
    fi
fi

# Create a temporary directory for installation
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "Downloading Amazon Q CLI from $DOWNLOAD_URL..."
if ! curl --proto '=https' --tlsv1.2 -sSf "$DOWNLOAD_URL" -o "q.zip"; then
    echo "Error: Failed to download Amazon Q CLI."
    echo "Please check your internet connection and try again."
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Extracting files..."
if ! unzip -q q.zip; then
    echo "Error: Failed to extract the zip file."
    echo "Please make sure 'unzip' is installed on your system."
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Installing Amazon Q CLI..."
if ! ./q/install.sh; then
    echo "Error: Installation failed."
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up
cd - > /dev/null
rm -rf "$TEMP_DIR"

echo ""
echo "=== Installation Complete ==="
echo "Amazon Q CLI has been successfully installed!"
echo ""
echo "To start using Amazon Q CLI, run:"
echo "~/.local/bin/q chat"
echo "Or, even better, update the PATH variable accordingly":
echo "export PATH=$PATH:/home/ssm-user/.local/bin"
echo ""
echo "For help and available commands, run:"
echo "~/.local/bin/q --help"
echo ""
echo "Enjoy using Amazon Q CLI!"
