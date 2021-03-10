#!/bin/bash

set -e

function install_packages {
    function install_packages_by_machine {
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
            # Install Homebrew
            [[ ! -x "$(command -v brew)" ]] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            brew install coreutils
            brew install tmux
            brew install vifm
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
        function install_rust {
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

        # TODO: permissions issue
        function install_shell_color_scripts {
            # Clone repository
            git clone https://gitlab.com/dwt1/shell-color-scripts.git

            # Install `shell-color-scripts`
            cd shell-color-scripts
            rm -rf /opt/shell-color-scripts || return 1
            sudo mkdir -p /opt/shell-color-scripts/colorscripts || return 1
            sudo cp -rf colorscripts/* /opt/shell-color-scripts/colorscripts
            sudo cp colorscript.sh /usr/bin/colorscript

            cd ..
            rm -rf shell-color-scripts || return 1
        }

        install_rust
        install_nerd_fonts
        # install_shell_color_scripts    # TODO: permissions issue
    }

    install_packages_by_machine
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
    install_packages
    create_links
    create_dirs
}

main
