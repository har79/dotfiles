shopt -s checkwinsize
shopt -s expand_aliases
shopt -s globstar

# Git aliases
alias gad='git add -u'
alias gci='git commit'
alias gco='git checkout'
alias gdc='git diff --cached'
alias gdf='git diff'
alias gme='git merge'
alias grb='git rebase'
alias grs='git restore'
alias gst='git status'
alias gxl='git log --branches --date-order --graph --format=format:"%C(auto)%h %Cblue%d%Creset%C(auto) %s"'

# Mercurial compound aliases
alias h.a='hg amend -A'
alias h.ae='hg amend -A && hg evo -A'
alias h.aeu='hg amend -A && hg evo -A && hg fix --all && hg upload -a'
alias h.as='hg amend -A && hg sync -a'
alias h.ase='hg amend -A && hg sync -a && hg evo -A'
alias h.aseu='hg amend -A && hg sync -a && hg evo -A && hg fix --all && hg upload -a'
alias h.asu='hg amend -A && hg sync -a && hg fix --all && hg upload -a'
alias h.au='hg amend -A && hg fix --all && hg upload -a'
alias h.e='hg evo -A'
alias h.eu='hg evo -A && hg fix --all && hg upload -a'
alias h.s='hg sync -a'
alias h.se='hg sync -a && hg evo -A'
alias h.seu='hg sync -a && hg evo -A && hg fix --all && hg upload -a'
alias h.su='hg sync -a && hg fix --all && hg upload -a'
alias h.u='hg fix --all && hg upload -a'

# Mercurial simple aliases
alias ham='hg amend'
alias hci='hg commit'
alias hco='hg up'
alias hcx='cd . && clear && hg xl'
alias hdf='hg diff'
alias hev='hg evo'
alias hfu='hg fix && hg upload'
alias hfx='hg fix'
alias hnx='hg next'
alias hpr='hg prev'
alias hps='hg presubmit'
alias hrb='hg rebase'
alias hra='hg rebaseall'
alias hsp='hg split'
alias hst='hg status'
alias hsy='hg sync'
alias hup='hg upload'
alias hxl='hg xl'

# Corepack aliases
alias yarn="corepack yarn"
alias yarnpkg="corepack yarnpkg"
alias pnpm="corepack pnpm"
alias pnpx="corepack pnpx"
alias npm="corepack npm"
alias npx="corepack npx"

# Directory aliases
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

# Misc aliases
alias beep='echo -en "\007"'
alias egrep='egrep --color=auto'
alias find='fd'
alias fgrep='fgrep --color=auto'
#alias grep='grep --color=auto'
alias grep='rg'
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
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d .'

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
  local -r hl="\[\e[47m" ## base2 background
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

  local -r last="$base1\$([[ \$last == 0 ]] || echo \"$yellow\")$hl \$last"
  local -r jobnum="$base1\$([[ \j == 0 ]] || echo \"$cyan$hl [\j]\")"
  local -r user="$red\u$default@"
  local -r host="$green\h$default:"
  local -r cwd="$blue\w"
  # TODO add vcs (git, hg) support
  # local -r git="$violet\$(__git_ps1)"

  export PS2="> "
  export PS1="\n$PS1_PREFIX$last$jobnum $default \t $user$host$cwd$PS1_SUFFIX$default\n$PS2"
}

setPrompt

# Fixes https://github.com/microsoft/WSL/issues/2530
export TMUX_TMPDIR='/tmp'

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

