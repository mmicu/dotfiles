#!/bin/bash

set -e

INSTALL_NERD_FONTS=""

function install_packages {
    function install_packages_based_on_machine {
        function install_linux_packages {
            sudo apt-get update

            sudo apt-get install -y \
                curl                \
                fonts-powerline     \
                git                 \
                openssh-client      \
                tmux                \
                vifm                \
                vim                 \
                wget                \
                zsh
        }

        function install_mac_packages {
            function install_hb_package {
                local formula="$1"

                brew list "$formula" &> /dev/null || brew install "$formula"
            }

            # Install Homebrew
            [[ ! -x "$(command -v brew)" ]] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            install_hb_package coreutils
            install_hb_package tmux
            install_hb_package vifm
        }

        # Install certain packages based on the machine
        local machine="$(uname -s)"
        case "${machine}" in
            Linux*)  install_linux_packages;;
            Darwin*) install_mac_packages;;
            *)       echo "Unsupported machine \"${machine}\""
        esac
    }

    function install_common_packages {
        function install_python_packages {
            # TODO
            return
        }

        function install_rust_packages {
            # Install Rust
            [[ ! -d "$HOME/.cargo/bin" ]] && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

            # Install some packages
            cargo install bat
            cargo install bottom
            cargo install exa
        }

        function install_nerd_fonts {
            if [[ ! -d "nerd-fonts" ]]; then
                git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
            fi

            # Install `FiraCode` and `FiraMono`
            cd nerd-fonts
            ./install.sh FiraCode
            ./install.sh FiraMono

            cd ..
            rm -rf nerd-fonts
        }

        function install_shell_color_scripts {
            # Clone repository
            if [[ ! -d "shell-color-scripts" ]]; then
                git clone https://gitlab.com/dwt1/shell-color-scripts.git
            fi

            # Install `shell-color-scripts`
            cd shell-color-scripts
            sudo rm -rf /opt/shell-color-scripts || return 1
            sudo mkdir -p /opt/shell-color-scripts/colorscripts || return 1
            sudo cp -rf colorscripts/* /opt/shell-color-scripts/colorscripts
            sudo cp colorscript.sh ../.local/bin

            cd ..
            rm -rf shell-color-scripts
        }

        install_python_packages
        install_rust_packages

        if [[ -n "$INSTALL_NERD_FONTS" ]]; then
            install_nerd_fonts
        fi

        # install_shell_color_scripts  # Currently disabled
    }

    install_packages_based_on_machine
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

    # Link files
    create_link $dt_path/.config/vim/.vimrc $HOME/.vimrc
    create_link $dt_path/.config/.zprofile  $HOME/.zprofile

    # Link directories
    create_link $dt_path/.config $HOME
    create_link $dt_path/.local  $HOME

    # Change permissions to scripts store in `.local`
    chmod -R +x $HOME/.local/bin
}

function create_dirs {
    # Check `HISTFILE` in `.zshrc`
    mkdir -p $HOME/.cache/zsh
}

function main {
    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -f|--fonts) INSTALL_NERD_FONTS=1 ;;
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac

        shift
    done

    install_packages
    create_links
    create_dirs
}

main "$@"
