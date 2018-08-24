# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="spaceship"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#==============================================================================
# MY SETTINGS
#==============================================================================

# PDF Reader
function pdfreader(){
	zathura "$1" >/dev/null 2>&1 &
}
alias pdf=pdfreader

# Image viewver
function show_image(){
	gwenview "$1" >/dev/null 2>&1 &
}
alias img=show_image

# Run application wihout standart output
function quiet_runner(){
	"$1" "$2" >/dev/null 2>&1 &
}
alias silence=quiet_runner

# For latex. This script convert .png and .jpg images to eps
function convert_to_eps(){
    ~/.scripts/converter.sh "$@"
}
alias toeps=convert_to_eps

# ex - archive extractor
# usage: ex <file>
function ex() {
    if [ -f $1 ] ; then
    case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.tar.xz) tar xf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted via ex()" ;;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

# pack - archive packager
# usage: pack <file_1> <file_2> ...
function pack() {
    bad=0

    for var in "$@"
    do
        # If argument is file or directory.
        if ! $( [ -f "$var" ] || [ -d "$var" ] ) ; then
            echo "'$var' is not a valid file or directory."
            bad=1
        fi
    done

    # If all entities are valid pack it.
    echo "Packed files:"
    if [ $bad -eq 0 ] ; then
        tar -cvzf result.tar "$@"
    fi
}

# pdfsearch - search in all pdf's for pattern (in current directory)
# Usage: pdfsearch "pattern"
function pdfsearch(){
    find . -name '*.pdf' -exec sh -c "pdftotext \"{}\" - | grep --with-filename --label=\"{}\" --color \"$1\"" \;
}

#Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Some settings for tmux.
alias tmux="TERM=screen-256color-bce tmux"
#export TERM=screen-256color-bce

# Editor for pacman
export VISUAL="vim"

# Colored man pages
man() {
	env \
		LESS_TERMCAP_md=$'\e[1;36m' \
		LESS_TERMCAP_me=$'\e[0m' \
		LESS_TERMCAP_se=$'\e[0m' \
		LESS_TERMCAP_so=$'\e[1;40;92m' \
		LESS_TERMCAP_ue=$'\e[0m' \
		LESS_TERMCAP_us=$'\e[1;32m' \
			man "$@"
}

# Run ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > /tmp/.ssh-agent-thing
fi

if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(</tmp/.ssh-agent-thing)"
fi

# Just usefull aliases
# Applications
alias viml="/usr/bin/vim --servername vimlatex"
alias cal="cal -ym"
alias mc='. /usr/lib/mc/mc-wrapper.sh'
alias ipy='ipython3'

# Scripts
alias hot='sudo $HOME/.scripts/hotspot.sh'
alias eduroam='sudo silence $HOME/.scripts/eduroam.sh'
# alias vim="/usr/bin/vim"

# Go to directory
source ~/.shortcuts
# Commands
source ~/.commands

# For fun
alias rickroll="curl -L http://bit.ly/10hA8iC | bash"
alias weather="$HOME/.scripts/weather.sh"

# For unmount most recent removable drives use devmon -c
# To umount all removable devices type devmon -r

# Set specific autocomplete rulse for commands
# zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.o'
# style ':completion:*:*:pdf:*:*files' ignored-patterns '*.tex *.fls *.aux *.log'

# Minicom colors
export MINICOM="-m -c on"

export PATH=$PATH:$HOME/.local/bin

#==============================================================================
# Useful commands
#==============================================================================
# du -sh: size of the current directory

#==============================================================================
# Platformio set up
#==============================================================================
export PLATFORMIO_FORCE_COLOR=true

# export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true \
#   -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
