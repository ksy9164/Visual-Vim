#! /bin/bash

RED="\033[0;91m"
GREEN="\033[0;92m"
YELLOW="\033[0;93m"
BLUE="\033[0;94m"
CYAN="\033[0;96m"
WHITE="\033[0;97m"
LRED="\033[1;31m"
LGREEN="\033[1;32m"
LYELLOW="\033[1;33m"
LBLUE="\033[1;34m"
LCYAN="\033[1;36m"
LWHITE="\033[1;37m"
LG="\033[0;37m"
NC="\033[0m"


install_script_deps() {
  case $DISTRO in
  Debian)
    $sudo apt-get update
    $sudo apt-get install -y git
    ;;
  RedHat)
    $sudo yum clean expire-cache  # next yum invocation will update package metadata cache
    $sudo yum install -y git
    ;;
  Darwin)
    if ! type "brew" >/dev/null 2>&1; then
      show_error "brew is not available!"
      show_info "Sorry, we only support auto-install on macOS using Homebrew. Please install it and try again."
      exit 1
    fi
    brew update
    # Having Homebrew means that the user already has git.
    ;;
  esac
}

install_system_pkg() {
  # accepts three args: Debian-style name, RedHat-style name, and Homebrew-style name
  case $DISTRO in
  Debian)
    $sudo apt-get install -y $1
    ;;
  RedHat)
    $sudo yum install -y $2
    ;;
  Darwin)
    brew bundle --file=- <<EOS
brew "$3"
EOS
  esac
}

KNOWN_DISTRO="(Debian|Ubuntu|RedHat|CentOS|openSUSE|Amazon|Arista|SUSE)"
DISTRO=$(lsb_release -d 2>/dev/null | grep -Eo $KNOWN_DISTRO  || grep -Eo $KNOWN_DISTRO /etc/issue 2>/dev/null || uname -s)

echo "$DISTRO"

if [ $DISTRO = "Darwin" ]; then
  DISTRO="Darwin"
elif [ -f /etc/debian_version -o "$DISTRO" == "Debian" -o "$DISTRO" == "Ubuntu" ]; then
  DISTRO="Debian"
elif [ -f /etc/redhat-release -o "$DISTRO" == "RedHat" -o "$DISTRO" == "CentOS" -o "$DISTRO" == "Amazon" ]; then
  DISTRO="RedHat"
elif [ -f /etc/system-release -o "$DISTRO" == "Amazon" ]; then
  DISTRO="RedHat"
else
  show_error "Sorry, your host OS distribution is not supported by this script."
  show_info "Please send us a pull request or file an issue to support your environment!"
  exit 1
fi

INSTALL_PATH="$(pwd)/Visual-Vim"

if ! type "git" >/dev/null 2>&1; then
    echo "Git is not available!!"
    install_script_deps
    install_system_pkg "git"
fi

if ! type "tmux" >/dev/null 2>&1; then
    echo "Tmux is not available!!"
    install_script_deps
    install_system_pkg "tmux"
fi

git clone https://github.com/ksy9164/Visual-Vim.git

# make vv_setting.sh
cd Visual-Vim
mkdir session_log

echo "VV_INSTALL_PATH=$INSTALL_PATH" > vv_setting.sh
cat ./src/vv_func.sh >> vv_setting.sh

# profile_file setting
for PROFILE_FILE in "zshrc" "bashrc" "profile" "bash_profile"
do
    if [ -e "${HOME}/.${PROFILE_FILE}" ]
    then
    echo "VV_INSTALL_PATH=$INSTALL_PATH" >> "${HOME}/.${PROFILE_FILE}"
    echo "if [ -e \"\$VV_INSTALL_PATH/vv_setting.sh\" ]; then source \$VV_INSTALL_PATH/vv_setting.sh;fi" >> "${HOME}/.${PROFILE_FILE}"
    fi
done


# Vim settings
echo "Do you want to use Visual-Vim's vimrc,Vim-PlugIn settings?? (Y/N)"
read confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    cp ~/.vimrc ~/.vimrc_past
    cp $INSTALL_PATH/util/.vimrc ~
    install_system_pkg "ctags"
    install_system_pkg "vim-gnome"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    sudo vim -c 'PluginInstall' -c 'qa!'
    echo "Your past ~/.vimrc is moved ~/.vimrc_past"
fi

# Tmux settings
echo "Do you want to use Visual-Vim's tmux.conf setting?? (Y/N)"
read confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    cp ~/.tmux.conf ~/.tmux.conf_past
    cp $INSTALL_PATH/util/.tmux.conf ~
    echo "Your past ~/.tmux.conf is moved ~/.tmux.conf_past"
fi

