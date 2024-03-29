# environment variables
export COLORTERM=truecolor
export MICRO_TRUECOLOR=1
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export LESS=-R
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LESSCHARSET=utf-8
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"
export MANROFFOPT="-c"
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[m\]\$ "
export BAT_PAGER="less -R -+X"
export LESS="-R -+X"

# aliases
alias lsd='lsd --icon never --group-dirs first'
alias bat='bat --paging always'
alias delta='delta --paging always'
alias tmux='~/bin/tmux'
