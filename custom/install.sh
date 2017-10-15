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
  if [[ "$(readlink ${name})" == "${target}" ]]; then
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
  prompt "link dotfiles"

  [[ -e "${dir}/.gitignore" ]] && link "${dir}/.gitignore" ".gitignore"

  local file
  for file in $(ls -A "${dir}"); do
    case "${file}" in
      ".git" | ".gitignore" | ".gitmodules" | "custom" | "external" | "install" | "LICENSE" ) ;;
      *) gitignore  "${file}" || link "${dir}/${file}" "${file}" ;;
    esac
  done

  source_rc "bashrc"
  source_rc "vimrc"
}

# source_rc RC
source_rc() {
  local -r rc="$1"
  local target src
  for target in $(ls "${dir}/.${rc}."*); do
    src="source ${PWD}/$(basename -- "${target}")"
    if ! grep -Fxq "${src}" ".${rc}" 2>/dev/null; then
      echo "${src}" >> ".${rc}"
    fi
  done
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
