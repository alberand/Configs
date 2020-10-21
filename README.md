### Repository with .dotfiles for my Arch Linux machine

This is based on soft links:
```
~/.vimrc -> ~/.dotfiles/.vimrc
```

Install
```
git clone https://github.com/alberand/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
for file in $(find . -maxdepth 1 -type f -name ".*" -printf '%f\n'); do echo ln -s ~/.dotfiles/$file ~/$file; done
for obj in $(ls .config); do mv ~/.config/$obj /tmp/$obj; ln -s ~/.dotfiles/.config/$obj ~/.config/$obj; done
```

```
sudo ln -s 00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf
```

#### Required

* i3-gaps
* dmenu
* i3blocks
* vim
* zsh
* git
* firefox

#### Optional

* Zathura
* oh-my-zsh
