#!/bin/zsh
#
# Xavier Del Castillo
# Small script for a bottom right
# dzen status bar.
#

weather() {
    curl --silent "http://api.wunderground.com/api/5aae3b88d69e5097/conditions/q/Mexico/Hermosillo.json" | grep 'weather\"\|temp_c' | tr '\n' ' ' | sed 's/.*:"\(.*\)",.*:\(.*\),/\2° \1/'
}

ftime(){
    date +"%b %d %H:%M"    
}

fpacupdates(){
    pacman -Qu | wc -l
}

weatherival=20
pacival=120

while true ; do
    if [[ pacival -eq 120 ]]; then
        pacupdates=$(fpacupdates)
        pacival=0
    fi

    if [[ weatherival -eq 20 ]]; then
        weatherupdate=$(weather)
        weatherival=0
    fi

    print "^fg(yellow)^i(/home/chuy/.dzen/dzenIcons/pacman.xbm) ^fg(white)$pacupdates updates | ^fg(gray)weather: ^fg(white)$weatherupdate | $(ftime)"
    
    let weatherival++
    let pacival++
    sleep 30

done

