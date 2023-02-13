git clone https://github.com/tmux/tmux.git
cd tmux
sudo apt install -y gcc
sudo apt install -y libevent-dev
sudo apt install -y autotools-dev
sudo apt install -y automake
sudo apt install -y ncurses-dev
git checkout 2.1
sh autogen.sh
./configure && make
