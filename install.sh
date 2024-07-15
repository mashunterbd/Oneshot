#!/bin/bash

# Detect the system
ARCH=$(uname -m)
HOSTNAME=$(hostname)
OS=$(uname -o)
DISTRO=""

# Determine the distribution
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO=$ID
elif [[ -f /etc/redhat-release ]]; then
    DISTRO=$(cat /etc/redhat-release | awk '{print tolower($1)}')
fi

echo "System architecture: $ARCH"
echo "System hostname: $HOSTNAME"
echo "Operating system: $OS"
echo "Distribution: $DISTRO"

# Function to check and install required packages
install_packages() {
    packages=("$@")
    for pkg in "${packages[@]}"; do
        if ! command -v "$pkg" &> /dev/null; then
            echo "Installing $pkg..."
            case "$DISTRO" in
                debian|ubuntu|kali|parrot)
                    sudo apt-get install -y "$pkg"
                    ;;
                centos|rhel|fedora)
                    sudo yum install -y "$pkg"
                    ;;
                *)
                    echo "Unsupported distribution: $DISTRO"
                    exit 1
                    ;;
            esac
        else
            echo "$pkg is already installed."
        fi
    done
}

# Function to download and set up Oneshot tool
setup_oneshot() {
    echo "Downloading Oneshot tool..."
    wget -O oneshot.py https://raw.githubusercontent.com/mashunterbd/Oneshot/master/oneshot.py
    chmod +x oneshot.py
    echo "Necessary package setup complete"
    echo "Execute permission complete"
    echo "Run command: python3 oneshot.py -i wlan0 --iface-down -K"
}

# Detect the specific system and install packages accordingly
if [[ "$OS" == *"Android"* ]]; then
    echo "We detected you are using Termux Android"
    if ! command -v tsu &> /dev/null; then
        echo "This Oneshot tool is only for rooted devices. Exiting..."
        exit 1
    fi
    pkg install -y root-repo git tsu python wpa-supplicant pixiewps iw openssl
    setup_oneshot
else
    case "$DISTRO" in
        debian)
            echo "We detected you are using Debian"
            install_packages git python3 wpa_supplicant pixiewps iw openssl
            setup_oneshot
            ;;
        ubuntu)
            echo "We detected you are using Ubuntu"
            install_packages git python3 wpa_supplicant pixiewps iw openssl
            setup_oneshot
            ;;
        kali)
            echo "We detected you are using Kali Linux"
            install_packages git python3 wpa_supplicant pixiewps iw openssl
            setup_oneshot
            ;;
        parrot)
            echo "We detected you are using Parrot OS"
            install_packages git python3 wpa_supplicant pixiewps iw openssl
            setup_oneshot
            ;;
        centos|rhel)
            echo "We detected you are using CentOS or RHEL"
            install_packages git python3 wpa_supplicant pixiewps iw openssl
            setup_oneshot
            ;;
        fedora)
            echo "We detected you are using Fedora"
            install_packages git python3 wpa_supplicant pixiewps iw openssl
            setup_oneshot
            ;;
        *)
            echo "Unsupported operating system: $DISTRO"
            exit 1
            ;;
    esac
fi
