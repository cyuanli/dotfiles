bindkey "^[[3~"   delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3;5~" kill-word
bindkey "^H"      backward-kill-word

HISTFILE=$HOME/.zsh_history
HISTFILESIZE=1000000
HISTSIZE=100000
SAVEHIST=100000
HISTTIMEFORMAT="%F %T "

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# My neat functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

export ANDROID_HOME=/home/cyl/Android/Sdk
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
