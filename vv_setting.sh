export TERM="xterm-256color"

# color define
RED='\033[1;31m'
NC='\033[0m'
BLU='\033[0;34m'
YEL='\033[1;33m'
CY='\033[0;36m'
LCY='\033[1;36m'

vvc(){
    if [[ ($1 == "ls" ) ||  ($1 == "list") ]]; then
        echo -e "${LCY}Visual-Vim Session list$(tput sgr 0) "
        echo -e "------------------------${NC}"
        session_list_txt=$(ls ~/Visual-Vim/session_log/)
        session_list=$(echo "$session_list_txt" | cut -d "." -f1)

        for i in $session_list ; do
            session_item=$(cat ~/Visual-Vim/session_log/$i.txt | cut -d "!" -f2 | head -1)
            echo -e "${YEL}Session number ${RED}$i${NC}"
            echo -e "${LCY}VV component :${CY}$session_item${NC}"
            echo ""
        done
        return 1
    elif [[ ($1 == "attach" ) ||  ($1 == "a") ]]; then
        tmux attach -t $2
    elif [[ ($1 == "kill" ) ||  ($1 == "k") ]]; then
        rm ~/Visual-Vim/session_log/$2.txt
        tmux kill-session -t $2
        echo -e "${YEL}kill VV session $2${NC}"
    elif [[ ($1 == "help" ) ||  ($1 == "h") ]]; then
        
        echo -e "${LCY}Visual-Vim Command list$(tput sgr 0) "
        echo -e "------------------------${NC}"
        echo -e "1. ${YEL}vvc list (ls)${NC}"
        echo -e "${LCY}Shows the currently running VV session list${NC}"
        echo -e "ex) ${NC} \$ vvc ls ${NC}"
        echo ""

        echo -e "2. ${YEL}vvc attach (a)${NC}"
        echo -e "${LCY}Reactivate the VV session${NC}"
        echo -e "vvc a \$Session_number"
        echo -e "ex) ${NC} \$ vvc a 1${NC}"
        echo ""

        echo -e "3. ${YEL}vvc kill (k)${NC}"
        echo -e "${LCY}Remove the running VV session${NC}"
        echo -e "vvc k \$Session_number"
        echo -e "ex) ${NC} \$ vvc k 1${NC}"
        
    fi
}
vv(){
    local file_name=$@
    screen_id=$(tty)
    sc=$(echo "$screen_id" | cut -c 10-14)

    #create session
    if [ -e ~/Visual-Vim/session_log/$sc.txt ]
    then
        echo -e "${RED}$sc screen exist error!!"
    else
        touch ~/Visual-Vim/session_log/$sc.txt

        tmux new-session -s $sc -n '$sc' -d
        tmux splitw -h -p 5 -t 0
        tmux splitw -v -p 50 -t 0
        tmux splitw -h -p 50 -t 2
        # Terminal , Board rate (2560 X 1440) => 15 170
        tmux resize-pane -t 2 -y 11
        # Htop Terminal rate
        tmux resize-pane -t 2 -x 115

        echo "$sc$screen_id ! $@ !" >> ~/Visual-Vim/session_log/$sc.txt

        # tmux send-keys -t 0 "data=$sc_term$("tty")" C-j

        tmux send-keys -t 0 "write_id $sc" C-j
        tmux send-keys -t 1 "write_id $sc" C-j
        tmux send-keys -t 2 "write_id $sc" C-j
        tmux send-keys -t 3 "write_id $sc" C-j

        tmux send-keys -t 1 "clear" C-j
        tmux send-keys -t 2 "clear" C-j

        tmux send-keys -t 3 "htop" C-j
        tmux send-keys -t 0 "vi $file_name" C-j

        tmux select-pane -t 2
        tmux select-pane -t 0

        tmux attach -t $sc
    fi
}

write_id(){
    t_id=$("tty")
    b=$1
    s_id=$(echo "$b" | cut -d "C" -f1)
    data="$s_id$t_id"
    echo "$data" >> ~/Visual-Vim/session_log/$s_id.txt
}

vq(){
    t_id=$("tty")
    data=$(cat ~/Visual-Vim/session_log/* | grep "$t_id")
    s_id=$(echo "$data" | cut -d "/" -f1)
    s_file=$s_id.txt
    rm ~/Visual-Vim/session_log/$s_file
    tmux kill-session -t $s_id
}

vd(){
    tmux detach
}

gd(){
 t_id=$("tty")
 target=$(cat ~/Visual-Vim/session_log/* | grep "$t_id")
 sc=$(echo "$target" | cut -d "/" -f1)
 tmux select-pane -t 1
 local file_name=$@
 tmux resize-pane -t 1 -x 115
 tmux splitw -v -p 30 -t 1 #2
 tmux select-pane -t 1
 tmux splitw -v -p 70 -t 1 #6
 
 tmux select-pane -t 2
 tmux splitw -h -p 50 -t 2 #3
 tmux select-pane -t 3
 tmux splitw -v -p 25 -t 3 #4
 tmux select-pane -t 3
 tmux splitw -v -p 25 -t 3 #5

 tmux select-pane -t 6
 tmux splitw -h -p 47 -t 6 #7

 #source pain
 tmux send-keys -t 1 "write_id $sc" C-j
 tmux send-keys -t 1 "TA" C-j
 
 tmux send-keys -t 2 "write_id $sc" C-j
 tmux send-keys -t 2 "TB" C-j
 
 tmux send-keys -t 3 "write_id $sc" C-j
 tmux send-keys -t 3 "TC" C-j
 
 tmux send-keys -t 4 "write_id $sc" C-j
 tmux send-keys -t 4 "TD" C-j
 
 tmux send-keys -t 5 "write_id $sc" C-j
 tmux send-keys -t 5 "TE" C-j
 
 tmux send-keys -t 7 "write_id $sc" C-j
 tmux send-keys -t 7 "TF" C-j
 
 tmux send-keys -t 6 "write_id $sc" C-j
 tmux send-keys -t 6 "gdb $file_name" C-j

 tmux select-pane -t 6
}

TA(){
    a=$("tty")
    echo "dashboard source -output $a" > ~/Visual-Vim/gdb_log/log.txt
    clear
}
TB(){
    b=$("tty")
    echo "dashboard local_variables -output $b" >> ~/Visual-Vim/gdb_log/log.txt
    clear
}
TC(){
    c=$("tty")
    echo "dashboard watch_points -output $c" >> ~/Visual-Vim/gdb_log/log.txt
    clear
}
TD(){
    d=$("tty")
    echo "dashboard threads -output $d" >> ~/Visual-Vim/gdb_log/log.txt
    clear
}
TE(){
    e=$("tty")
    echo "dashboard stack -output $e" >> ~/Visual-Vim/gdb_log/log.txt
    clear
}
TF(){
    f=$("tty")
    echo "dashboard assembly -output $f" >> ~/Visual-Vim/gdb_log/log.txt
    clear
}
