#!/bin/sh
set -eu

# Globals
readonly DIR="${PWD}/$(dirname -- "$0")"

readonly OS="$(uname)"
if [[ "${OS}" == "Linux" ]]; then
  readonly DISTRO="$(lsb_release -si)"
fi

case "${OS}" in
  "Linux")
    POWERLINE="$(ls -d ~/.local/lib/python*/site-packages/powerline/)"
    case "${DISTRO}" in
      "openSUSE project")
        INSTALL="zypper in"
        ;;
      *)
        err_unsupported "Linux distro \"${DISTRO}\""
    esac
    ;;
  "Darwin")
    POWERLINE="~/Library/Python/2.7/lib/python/site-packages/powerline"
    INSTALL="brew install"
    ;;
  *)
    err_unsupported "Operating system \"${OS}\""
esac
readonly POWERLINE
readonly INSTALL

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
  done < .gitignore
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
    if [[ -e "${name}" ]]; then
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

install_deps() {
  local -r deps="cmake gcc-c++ mercurial python-devel python-pip tmux"
  prompt "install the following packages: ${deps}"
  install ${deps}
}

link_dotfiles() {
  prompt "link dotfiles"
  local file
  for file in $(ls -A .dotfiles/); do
    case "${file}" in
      ".git" | ".gitmodules" | "custom" ) ;;
      *) gitignore "${file}" || link "${PWD}/.dotfiles/${file}" "${file}" ;;
    esac
  done

  local -r srcbashrc=". ${PWD}/.bashrc.local"
  if ! grep -Fxq "${srcbashrc}" .bashrc; then
    echo "${srcbashrc}" >> .bashrc
  fi
}

install_powerline() {
  prompt "install Powerline"
  ( cd "${DIR}/powerline-fonts"; ./install.sh; )
  echo -e "\e[0;31mChange the font in your terminal emulator to 'DejaVu Sans Mono for Powerline'.\e[m"
  pip install --user git+git://github.com/Lokaltog/powerline
  link "${PWD}/.dotfiles/custom/powerline" ".config/"
  link "${POWERLINE}" ".powerline"
  link "${PWD}/.dotfiles/custom/powerline/custom.py" ".powerline/segments/"
}

install_vim_plugins() {
  prompt "install vim plugins"
  [[ -e ".vim/bundle/Vundle.vim" ]] ||
    git clone https://github.com/gmarik/Vundle.vim.git .vim/bundle/Vundle.vim
  vim +PluginInstall +GoInstallBinaries +qall
  .vim/bundle/YouCompleteMe/install.sh >/dev/null
}

install_kde_solarized() {
  if [[ -d ~/.kde || -d ~/.kde4 ]]; then
    prompt "install Solarized colour schemes for KDE"
    ( cd "${DIR}/kde-solarized"; ./install.sh; )
  fi
}

main() {

  cd ~

  install_deps
  link_dotfiles
  install_powerline
  install_vim_plugins
  install_kde_solarized

  echo "Reopen any bash sessions to make use of the new goodness."
}

main "$@"
