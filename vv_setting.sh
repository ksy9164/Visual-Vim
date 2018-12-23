export TERM="xterm-256color"

vv(){
 if [[ $@ == "ls" ]]; then
    echo "Visual-Vim Session list "
    session_list_txt=$(ls ~/Visual-Vim/session_log/)
    session_list=$(echo "$session_list_txt" | cut -d "." -f1)
    for i in $session_list ; do
        echo "Session number $i"
    done
    return 1
 fi
 local file_name=$@
 screen_id=$(tty)
 sc=$(echo "$screen_id" | cut -c 10-14)

 #create session
if [ -e ~/Visual-Vim/session_log/$sc.txt ]
then
    echo " $sc screen exist error!!"
else
    touch ~/Visual-Vim/session_log/$sc.txt

    tmux new-session -s $sc -n '$sc' -d
    tmux splitw -h -p 5 -t 0
    tmux splitw -v -p 50 -t 0
    tmux splitw -h -p 50 -t 2
    tmux resize-pane -t 2 -y 11
    tmux resize-pane -t 2 -x 115

    echo "$sc$screen_id" >> ~/Visual-Vim/session_log/$sc.txt
    
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
