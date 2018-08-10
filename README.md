### Repositor with dotfiles for my Arch Linux machine

At the directories where those files should be, are soft links to these files.

For example:
```
~/.vimrc -> ~/.dotfiles/.vimrc
```

Install
```
git clone https://github.com/alberand/dotfiles.git ~/.dotfiles
cd .dotfiles
for file in $(ls); do echo ln -s ~/.dotfiles/$file ~/$file; done
```
