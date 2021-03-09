# dotfiles


## Installation
```
$ bash install.sh
```


## Manual steps


### SSH keys
```
$ email=...
$ ssh-keygen -t rsa -b 4096 -C "$email"
```


### tmux
Use `tpm` to install the plugins by using `prefix + I`.
Then, reload the configuration with:

```
$ tmux source $HOME/.config/tmux/tmux.conf
```


### vim
```
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Then, from `vim` runs `:PlugInstall`


### git
```
$ git_first_name="..."
$ git_last_name="..."
$ git_email="..."
$ git config --global user.name "$git_first_name $git_last_name"
$ git config --global user.email "$git_email"
```


### Change hostname on Mac OS X
Run the command below and then restart the system.

```
$ new_hostname="..."
$ sudo scutil --set ComputerName "$new_hostname"
$ sudo scutil --set LocalHostName "$new_hostname"
$ sudo scutil --set HostName "$new_hostname"
```
