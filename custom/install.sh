#!/bin/sh
set -eu

function set_globals {
  # Globals
  readonly OS="$(uname)"
  if [[ "${OS}" == "Linux" ]]; then
    readonly DISTRO="$(lsb_release -si)"
  fi

  case "${OS}" in
    "Linux")
      GIT_PS1="/usr/lib/git-core/git-sh-prompt"
      POWERLINE="$(ls -d ~/.local/lib/python*/site-packages/powerline/)"
      case "${DISTRO}" in
        "openSUSE project")
          INSTALL="zypper in"
          ;;
        "Ubuntu")
          INSTALL="aptitude install"
          ;;
        *)
          err_unsupported "Linux distro \"${DISTRO}\""
      esac
      ;;
    "Darwin")
      GIT_PS1="$(brew --prefix)/etc/bash_completion.d/git-prompt.sh"
      INSTALL="brew install"
      POWERLINE="~/Library/Python/2.7/lib/python/site-packages/powerline"
      ;;
    *)
      err_unsupported "Operating system \"${OS}\""
  esac
  readonly GIT_PS1
  readonly INSTALL
  readonly POWERLINE
}

# err_unsupported SYSTEM
#
# Prints "SYSTEM is not supported" to stdout, then exits with status 64.
err_unsupported() {
  echo "$1 is not supported." >&2
  exit 64
}

gitignore() {
  while read glob; do
    [[ "$1" == ${glob} ]] && return 0
  done < ~/.gitignore
  return 1
}

# install PKG [PKG]...
#
# Installs PKG.
install() {
  sudo ${INSTALL} "$@"
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
git_submodules() {
  local -r dir="$1"
  prompt "update git submodules"
  ( cd "${dir}" && git submodule update --init )
}

# install_deps
install_deps() {
  local -r deps="cmake gcc-c++ mercurial python-devel python-pip tmux"
  prompt "install the following packages: ${deps}"
  install ${deps}
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

# install_powerline DIR
install_powerline() {
  local -r dir="$1"
  prompt "install Powerline"
  ( cd "${dir}/custom/powerline-fonts"; ./install.sh; )
  echo -e "\e[0;31mChange the font in your terminal emulator to 'DejaVu Sans Mono for Powerline'.\e[m"
  pip install --user git+git://github.com/Lokaltog/powerline
  link "${dir}/custom/powerline" ".config/"
  link "${dir}/custom/powerline/custom.py" ".powerline/segments/"
}

# install_vim_plugins
install_vim_plugins() {
  prompt "install vim plugins"
  if [[ ! -e ".vim/bundle/Vundle.vim" ]]; then
    git clone https://github.com/gmarik/Vundle.vim.git .vim/bundle/Vundle.vim
  fi
  vim +PluginInstall +GoInstallBinaries +qall
  if [[ -e ".vim/bundle/YouCompleteMe/install.sh" ]]; then
    .vim/bundle/YouCompleteMe/install.sh
  fi
}

# install_kde_solarized DIR
install_kde_solarized() {
  local -r dir="$1"
  if [[ -d ~/.kde || -d ~/.kde4 ]]; then
    prompt "install Solarized colour schemes for KDE"
    ( cd "${dir}/custom/kde-solarized"; ./install.sh; )
  fi
}
