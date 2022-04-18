#!/bin/bash

set -e

INSTALL_NERD_FONTS=
INSTALL_PYTHON_PACKAGES=
INSTALL_RUST_PACKAGES=

install_programs() {
    install_programs_based_on_machine() {
        install_linux_packages() {
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

        install_mac_packages() {
            install_hb_package() {
                local formula="$1"

                brew list "$formula" &> /dev/null || brew install "$formula"
            }

            # Install Homebrew
            [[ ! -x "$(command -v brew)" ]] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            install_hb_package coreutils
            install_hb_package tmux
            install_hb_package vifm
            install_hb_package shellcheck
        }

        # Install certain packages based on the machine
        local machine
        machine="$(uname -s)"
        case "${machine}" in
            Linux*)  install_linux_packages;;
            Darwin*) install_mac_packages;;
            *)       echo "Unsupported machine \"${machine}\""
        esac
    }

    install_nerd_fonts() {
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

    install_python_packages() {
        # TODO
        return
    }

    install_rust_packages() {
        # Install Rust
        [[ ! -d "$HOME/.cargo/bin" ]] && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

        # Install some packages
        cargo install bat
        cargo install bottom
        cargo install exa
    }

    install_programs_based_on_machine

    if [[ -n "$INSTALL_NERD_FONTS" ]]; then
        install_nerd_fonts
    fi

    if [[ -n "$INSTALL_PYTHON_PACKAGES" ]]; then
        install_python_packages
    fi

    if [[ -n "$INSTALL_RUST_PACKAGES" ]]; then
        install_rust_packages
    fi
}

create_links() {
    create_link() {
        local src="$1"
        local dst="$2"

        if [[ -f "$src" ]] || [[ -d "$src" ]]; then
            echo "Creating link from '$src' to '$dst'"
            ln -s -f "$src" "$dst"
        else
            echo "Skipping source '$src' since it does not exist"
        fi
    }

    local dt_path
    dt_path="$(realpath "$(pwd)")"

    # Link files
    create_link "$dt_path/.config/vim/.vimrc" "$HOME/.vimrc"
    create_link "$dt_path/.config/.zprofile"  "$HOME/.zprofile"

    # Link directories
    create_link "$dt_path/.config" "$HOME"
    create_link "$dt_path/.local"  "$HOME"

    # Change permissions to scripts store in `.local`
    chmod -R +x "$HOME/.local/bin"
}

create_dirs() {
    # Check `HISTFILE` in `.zshrc`
    mkdir -p "$HOME/.cache/zsh"
}

main() {
    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -f|--fonts) INSTALL_NERD_FONTS=1 ;;
            -pp|--python-packages) INSTALL_PYTHON_PACKAGES=1 ;;
            -rp|--rust-packages) INSTALL_RUST_PACKAGES=1 ;;
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac

        shift
    done

    install_programs
    create_links
    create_dirs
}

main "$@"
