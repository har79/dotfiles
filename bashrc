shopt -s checkwinsize
shopt -s expand_aliases
shopt -s globstar

alias +='pushd .'
alias -- -='popd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias beep='echo -en "\007"'
alias egrep='egrep --color=auto'
alias fd='fdfind'
alias fgrep='fgrep --color=auto'
alias gad='git add -u'
alias gci='git commit'
alias gco='git checkout'
alias gdf='git diff'
alias gdc='git diff --cached'
alias gst='git status'
alias gitgraph='git log --branches --date-order --graph --format=format:"%C(auto)%h %Cblue%d%Creset%C(auto) %s"'
alias grep='grep --color=auto'
alias l='ll -a'
alias la='ls -a'
alias ll='ls -lh'
alias loginstatus='true'
alias ls='ls --color=auto'
alias md='mkdir -p'
alias nv='nvim'
alias o='less'
alias page='sed -E "s/(.{$(tput cols)}).*/\1/;$(($(tput lines)-$(echo -en $PS1 | wc -l)))q"'
alias rd='rmdir'
# Trailing space causes the next word to be checked for alias substitution.
alias sudo='sudo '
alias tmux='tmux -2'
alias unmount=umount
# Trailing space causes the next word to be checked for alias substitution.
alias xargs='xargs '

export EDITOR=/usr/bin/nvim
export FZF_DEFAULT_COMMAND='fdfind --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d .'

export PATH="${PATH}"\
":${HOME}/.local/bin"\
":${HOME}/.pub-cache/bin"\
":/sbin"\
":/usr/sbin"\
""

# Exit if not interactive
[[ "$-" != *i* ]] && return

[[ -r ~/.dir_colors ]] && eval "$(dircolors ~/.dir_colors)"

set -o vi

setPrompt() {
  # Solarized
  local -r default="\[\e[m"
  local -r hl="\[\e[40m" ## base02 background
  local -r base03="\[\e[1;30m"
  local -r base02="\[\e[0;30m"
  local -r base01="\[\e[1;32m"
  local -r base00="\[\e[1;33m"
  local -r base0="\[\e[1;34m"
  local -r base1="\[\e[1;36m"
  local -r base2="\[\e[0;37m"
  local -r base3="\[\e[1;37m"
  local -r red="\[\e[0;31m"
  local -r orange="\[\e[1;31m"
  local -r yellow="\[\e[0;33m"
  local -r green="\[\e[0;32m"
  local -r cyan="\[\e[0;36m"
  local -r blue="\[\e[0;34m"
  local -r violet="\[\e[1;35m"
  local -r magenta="\[\e[0;35m"

  export PROMPT_COMMAND='last="$?"'

  local -r last="$base01\$([[ \$last == 0 ]] || echo \"$yellow\")$hl \$last"
  local -r jobnum="$base01\$([[ \j == 0 ]] || echo \"$cyan$hl [\j]\")"
  local -r user="$red\u$default@"
  local -r host="$green\h$default:"
  local -r cwd="$blue\w"
  # TODO add vcs (git, hg) support
  # local -r git="$violet\$(__git_ps1)"

  export PS2="> "
  export PS1="\n$PS1_PREFIX$last$jobnum $default \t $user$host$cwd$PS1_SUFFIX$default\n$PS2"
}

setPrompt

type tmx &>/dev/null || function tmx() {
  session="$(tmux ls | sed -n -r '/attached/ !{s/^([^:]+):.*/\1/;x}; ${x;p}')"
  tmux ${session:+attach}
}

selectHost() {
  [[ "$TMUX" ]] && return 1

  local hosts=()
  if [ -f ~/.ssh/config ]; then
    hosts=($(sed -nE 's/\s*Host\s+(\S+).*/\1/p' ~/.ssh/config))
  fi

  [[ ${#hosts[@]} == 0 ]] && { tmx; return; }

  PS3='Select host: '
  select opt in "localhost" ${hosts[@]/"$(hostname -s)"}; do
    if [[ "$opt" == "localhost" ]]; then
      tmx
    else
      ssh "$opt" 2>/dev/null
    fi
  done
}

selectHost

