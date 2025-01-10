#!/bin/bash

### Scripted instructions from https://www.gnu.org/software/mit-scheme/documentation/stable/mit-scheme-user/Unix-Installation.html
### Use this for a RPM-based system (I have this working on Fedora, for example)

# Ensure running as root for installation
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root!"
    exit
fi

# Install dependencies
echo "Installing dependencies..."
dnf upgrade -y
dnf install -y gcc make m4 ncurses-devel

# Find the latest version of MIT Scheme
echo "Finding latest MIT Scheme version..."
LATEST_VERSION=$(wget -qO- "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/" | grep -oP 'href="\K[^"]*' | grep -E '^[0-9]+\.[0-9]+' | sort -V | tail -n 1)

# Build URL based off of latest ver found
SCHEME_TARBALL="https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/${LATEST_VERSION}mit-scheme-${LATEST_VERSION%/}-x86-64.tar.gz"

# Download the source tar file
if [ ! -f "mit-scheme-${LATEST_VERSION}.tar.gz" ]; then
    echo "Downloading MIT Scheme ${LATEST_VERSION%/}..."
    wget "$SCHEME_TARBALL" -O "mit-scheme.tar.gz"
fi

# Extract the tar
echo "Extracting tarball..."
tar -xzf "mit-scheme.tar.gz"

# Change into the src dir and configure, build
cd "mit-scheme-${LATEST_VERSION%/}/src"
echo "Configuring and Building..."
./configure
make

# Install MIT Scheme
echo "Installing Scheme..."
make install

# Verify installation
echo "Verifying MIT Scheme installation..."
if command -v scheme > /dev/null 2>&1; then
    echo "MIT Scheme installed successfully!"
else
    echo "MIT Scheme installation failed."
fi
