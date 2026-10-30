function fish_right_prompt --description "Write out the right prompt"
    echo -n -s (set_color purple) (date +'%m/%d/%Y %a %I:%M:%S %p') (set_color --reset)
end
