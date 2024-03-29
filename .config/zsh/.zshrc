# Enable colors and change prompt
autoload -U colors && colors
# NOTE: not used now. It is overwritten by `git-prompt.zsh`
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%} $%b "

# autocd
setopt autocd

# Turn off all beeps
unsetopt BEEP
# Turn off autocomplete beeps
unsetopt LIST_BEEP

# History
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $HOME/.cache/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots)    # Include hidden files

# vi mode
bindkey -v
bindkey '^R' history-incremental-search-backward
export KEYTIMEOUT=1

# SSH agent
if [[ -z ${SSH_AGENT_PID} ]]; then
    eval `ssh-agent`
fi

# Plugins
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2> /dev/null
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh         2> /dev/null
source $ZDOTDIR/plugins/pass-zsh-completion/pass-zsh-completion.plugin      2> /dev/null
source $ZDOTDIR/plugins/git-prompt.zsh/git-prompt.zsh                       2> /dev/null

# Load theme
source $ZDOTDIR/themes/multiline.zsh 2> /dev/null

# Load aliases
[ -f "${XDG_CONFIG_HOME}/aliasrc" ] && source "${XDG_CONFIG_HOME}/aliasrc"
# Additional aliases based on the machine
[ -f "${XDG_CONFIG_HOME}/local-aliasrc" ] && source "${XDG_CONFIG_HOME}/local-aliasrc"
