git clone https://github.com/tmux/tmux.git
cd tmux
sudo apt install gcc
sudo apt install libevent-dev
sudo apt install autotools-dev
sudo apt install automake
sudo apt-get install ncurses-dev
sudo apt install apt
sh autogen.sh
./configure && make
