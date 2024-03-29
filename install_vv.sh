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

install_script_deps() {
    case $DISTRO in
        Debian)
            sudo apt-get update
            sudo apt-get install -y git
            ;;
        RedHat)
            sudo yum clean expire-cache  # next yum invocation will update package metadata cache
            sudo yum install -y git
            ;;
        Darwin)
            if ! type "brew" >/dev/null 2>&1; then
                echo "brew is not available!"
                echo "Sorry, we only support auto-install on macOS using Homebrew. Please install it and try again."
                exit 1
            fi
            brew update
            # Having Homebrew means that the user already has git.
            ;;
    esac
}

install_system_pkg() {
    case $DISTRO in
        Debian)
            sudo apt-get install -y $1
            ;;
        RedHat)
            sudo yum install -y $1
            ;;
        Darwin)
            brew install -y $1
    esac
}

make_vv_script() {
    echo "VV_INSTALL_PATH=$INSTALL_PATH" > vv_setting.sh
    case $DISTRO in
        Debian)
            cat ./src/ubuntu/vv_func.sh >> vv_setting.sh
            ;;
        RedHat)
            cat ./src/redhat/vv_func.sh >> vv_setting.sh
            ;;
        Darwin)
            cat ./src/darwin/vv_func.sh >> vv_setting.sh
    esac
}

install_vv_mux() {
    case $DISTRO in
        Debian)
            ubuntu_version=$(lsb_release -r)
            echo "Installing VVmux"
            cd utils
            chmod +x ./install_vvmux.sh
            ./install_vvmux.sh
            cd ../
            ;;
        RedHat)
            echo "VVmux is not prepared"
            ;;
        Darwin)
            echo "VVmux is not prepared"
    esac
}

#Start VVmux install
INSTALL_PATH="$(pwd)/Visual-Vim"

install_script_deps

# Install Tmux
if ! type "tmux" >/dev/null 2>&1; then
    echo "Tmux is not available!!"
    install_system_pkg "tmux"
fi

# Install Htop
if ! type "htop" >/dev/null 2>&1; then
    echo "Htop is not available!!"
    install_system_pkg "htop"
fi

# Download Visual-Vim
git clone https://github.com/ksy9164/Visual-Vim.git

# make vv_setting.sh
cd Visual-Vim
mkdir session_log
chmod +wr session_log

install_vv_mux
make_vv_script

# profile_file setting
for PROFILE_FILE in "zshrc" "bashrc" "profile" "bash_profile"
do
    if [ -e "${HOME}/.${PROFILE_FILE}" ]
    then
        echo "VV_INSTALL_PATH=$INSTALL_PATH" >> "${HOME}/.${PROFILE_FILE}"
        echo "alias vvmux='$INSTALL_PATH/utils/tmux-2.1/tmux'" >> "${HOME}/.${PROFILE_FILE}"
        echo "if [ -e \"\$VV_INSTALL_PATH/vv_setting.sh\" ]; then source \$VV_INSTALL_PATH/vv_setting.sh;fi" >> "${HOME}/.${PROFILE_FILE}"
    fi
done

# Vim settings
echo "Do you want to use Visual-Vim's vimrc,Vim-PlugIn settings?? (Y/N)"
read confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    if [ -e "~/.vimrc" ]
    then
        cp ~/.vimrc ~/.vimrc_past
        echo "Your past ~/.vimrc is moved ~/.vimrc_past"
    fi
    cp $INSTALL_PATH/utils/.vimrc ~
    case $DISTRO in
        Debian)
            install_system_pkg "ctags"
            install_system_pkg "vim-gnome"
            install_system_pkg "vim-gui-common"
            ;;
        RedHat)
            install_system_pkg "ctags"
            install_system_pkg "vim-X11"
            ;;
        Darwin)
            install_system_pkg "ctags"
            install_system_pkg "reattach-to-user-namespace"
    esac
    git clone https://github.com/ksy9164/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim -c 'PluginInstall' -c 'qa!'
    sudo vim -c 'PluginInstall' -c 'qa!'
fi

# Tmux settings
echo "Do you want to use Visual-Vim's tmux.conf setting?? (Y/N)"
read confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    cp ~/.tmux.conf ~/.tmux.conf_past
    cp $INSTALL_PATH/utils/.tmux.conf ~
    echo "Your past ~/.tmux.conf is moved ~/.tmux.conf_past"
fi

