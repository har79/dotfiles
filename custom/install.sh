#!/bin/sh
set -eu

gitignore() {
  while read glob; do
    [[ "$1" == ${glob} ]] && return 0
  done < ~/.gitignore
  return 1
}

# link TARGET NAME
#
# Creates a symbolic link from NAME to TARGET, printing the result.
#
# If NAME already exists and is not a link to TARGET, it is first moved to
# "NAME.original".
link () {
  [[ "$1" && "$2" ]] || return
  local -r target="$1"
  local name="$2"
  if [[ ! -L "${name}" && -d "${name}" ]]; then
    name+="$(basename ${target})"
  fi
  readonly name

  echo -n "${name} -> ${target}"
  if [[ ! -e "${target}" ]]; then
    echo " (target doesn't exist)"
  elif [[ "$(readlink ${name})" == "${target}" ]]; then
    echo " (already exists)"
  else
    if [[ -e "${name}" || -L "${name}" ]]; then
      echo " (existing ${name} moved to ${name}.original)"
      mv "${name}"{,.original}
    else
      echo ""
    fi
    ln -s "${target}" "${name}"
  fi
}

# source_rc TARGET RC
#
# Sources TARGET from RC.
source_rc() {
  local -r target="$1"
  local -r rc="$2"
  local -r src="source ${target}"
  echo -n "${rc} => ${target}"
  if grep -Fxq "${src}" "${rc}" 2>/dev/null; then
    echo " (already exists)"
  else
    echo ""
    echo "${src}" >> "${rc}"
  fi
}

# prompt MSG
#
# Prints "Press [Enter] to MSG", then waits for [Enter] to be pressed.
prompt() {
  echo ""
  echo -e "\e[0;34mPress [Enter] to $1\e[m"
  read
}

# link_dotfiles DIR
link_dotfiles() {
  local -r dir="$1"
  prompt "link (->) and source (=>) dotfiles"

  local file
  for file in bin.local .dir_colors .gitconfig .tmux.conf; do
    link "${dir}/${file}" "${file}"
  done

  source_rc "${dir}/bashrc" ".bashrc"
  source_rc "${dir}/nvimrc" ".config/nvim/init.vim"
}

install_tmux_plugins() {
  prompt "install tmux plugins"
  if [[ ! -e ".tmux/plugins/tpm/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
  fi
}

# install_vim_plugins
install_vim_plugins() {
  prompt "install vim plugins"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall +GoInstallBinaries +qall
}
