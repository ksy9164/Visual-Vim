tar xvzf tmux_2.1.orig.tar.gz
cd tmux-2.1
sudo apt install -y gcc
sudo apt install -y libevent-dev
sudo apt install -y autotools-dev
sudo apt install -y automake
sudo apt install -y ncurses-dev
./configure && make
