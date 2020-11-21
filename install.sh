#!/bin/bash

set -e

function install_packages {
    # sudo apt-get update

    # sudo apt-get install -y \
    #     vim \
    #     wget \
    #     zsh \
    #     openssh-client \
    #     git \
    #     fonts-powerline

    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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
    # Install packages by using apt
    install_packages

    # Create symbolic links
    # create_links

    # sudo chmod -R 777 $HOME/.local/bin /etc/wsl.conf /etc/resolv.cof
}

main
