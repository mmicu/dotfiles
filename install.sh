#!/bin/bash

set -e

function install_packages {
    function install_linux_packages {
        sudo apt-get update

        sudo apt-get install -y \
            vim \
            wget \
            zsh \
            openssh-client \
            git \
            fonts-powerline
    }

    function install_mac_packages {
        # Install Homebrew
        [[ ! -x "$(command -v brew)" ]] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    }

    function install_common_packages {
        # Install Rust
        [[ ! -d "$HOME/.cargo/bin" ]] && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    }

    # Install certain packages based on the machine
    machine="$(uname -s)"
    case "${machine}" in
        Linux*)  install_linux_packages;;
        Darwin*) install_mac_packages;;
        *)       echo "Unsupported machine \"${machine}\""
    esac

    # Install common packages
    install_common_packages
}

function create_links {
    function create_link {
        local src="$1"
        local dst="$2"

        if [[ -f "$src" ]] || [[ -d "$src" ]]; then
            echo "Creating link from '$src' to '$dst'"
            ln -s -f "$src" "$dst"
        else
            echo "Skipping source '$src' since it does not exist"
        fi
    }

    local dt_path="$(realpath `pwd`)"

    create_link $dt_path/.config   $HOME
    create_link $dt_path/.local    $HOME
    create_link $dt_path/.zprofile $HOME
}

function main {
    # Install packages
    install_packages

    # Create symbolic links
    # create_links

    # sudo chmod -R 777 $HOME/.local/bin /etc/wsl.conf /etc/resolv.conf
}

main
