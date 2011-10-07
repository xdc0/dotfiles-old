#!/bin/zsh
# xavier - Dzen2 main script largely based on some guy's script from arch bbs
#
# Dzen conf
#

ICONDIR=~/.dzen/dzenIcons
ICONCOL1="#f6db6c"
ICONCOL2="#780000"
BARFG="#780000"
BARBG="#212121"
SEGCOL="#212121"
SEPCOL="#999999"

# Configuration
DATE_FORMAT='%B %-d %R'
GCOUNT=0
GBLINK=0
ACOUNT=0
ABLINK=0

INTERVAL=5

DATEIVAL=12
MAILIVAL=60
PMIVAL=36
DISKIVAL=72
SYSIVAL=1
WEATHERIVAL=144
BLINKIVAL=1

# Functions
#fmail() { cat .scripts/mail }

fdate() { datetime=`date +$DATE_FORMAT`; echo "$datetime ^fg(#0066bb)^i($ICONDIR/arch_10x10.xbm)^fg(#)" }

fcpu() { awk '{print $1*100;}' /proc/loadavg }

fcputemp() { sensors | grep "CPU Temp" | awk '{print $3}' | sed 's/+//' }

fpacman() { pacman -Qu | wc -l }

fmem() { awk '/MemTotal/ {t=$2} /MemFree/ {f=$2} /^Cached/ {c=$2} END {print t-f-c " " t;}' /proc/meminfo | gdbar -h 8 -w 50 -o -fg $BARFG -bg $BARBG }

fweather() {
#    CUR=$(curl --silent 'http://api.wunderground.com/weatherstation/WXCurrentObXML.asp?ID=ISONORAH12' | grep temp_c | sed 's/.*>\([0-9]*\.[0-9]\).*/\1/')
#    echo "^fg($ICONCOL1)^i($ICONDIR/temp.xbm)^fg(#) $CUR°" 
    CUR=$(curl --silent "http://api.wunderground.com/api/5aae3b88d69e5097/conditions/q/Mexico/Hermosillo.json" | grep 'weather\"\|temp_c' | tr '\n' ' ' | sed 's/.*:"\(.*\)",.*:\(.*\),/\2° \1/')
    echo "^fg($ICONCOL1)^i($ICONDIR/temp.xbm)^fg(#) $CUR" 
}

# Disk1
fdiskusage1per() { df -h /|tail -n1|awk '{print $5}' }

# Disk2
fdiskusage2per() { df -h /home|tail -n1|awk '{print $5}' }

#fmail() {
    #pass=$(cat /opt/foobarquuz.txt)
    #wget --secure-protocol=TLSv1 --timeout=3 -t 1 -q -O - https://mail.google:${pass}@mail.google.com/mail/feed/atom --no-check-certificate | grep 'fullcount' | sed -e 's/.*<fullcount>//;s/<\/fullcount>.*//'
#}


DATECOUNTER=$DATEIVAL
MAILCOUNTER=$MAILIVAL
PMCOUNTER=$PMIVAL
DISKCOUNTER=$DISKIVAL
MEMCOUNTER=$SYSIVAL
CPUCOUNTER=$SYSIVAL
SNAPSHOTCOUNTER=$SYSIVAL
WEATHERCOUNTER=$WEATHERIVAL
BLINKCOUNTER=$BLINKIVAL

while true; do
    if [ $DATECOUNTER -ge $DATEIVAL ]; then
        PDATE=$(fdate)
        DATECOUNTER=0
    fi

    if [ $PMCOUNTER -ge $PMIVAL ]; then
        NUM=$(fpacman)
        ACOUNT=$NUM
        PPM="$NUM"
        PMCOUNTER=0
    fi

#    if [ $MAILCOUNTER -ge $MAILIVAL ]; then
#        COUNT=$(fmail)
#        GCOUNT=$COUNT
#        #blink --c -r $COUNT
#        PMAIL=$COUNT
#        MAILCOUNTER=0
#    fi

    if [ $BLINKCOUNTER -ge $BLINKIVAL ]; then
        if [ $GCOUNT -ne 0 ]; then
            if [ $GBLINK -ne 0 ]; then
                PMICON="^fg($ICONCOL2)^i($ICONDIR/mail.xbm)^fg(#)"
                GBLINK=0
            else
                PMICON="^i($ICONDIR/mail.xbm)"
                GBLINK=1
            fi
        else
            PMICON="^i($ICONDIR/mail.xbm)"
        fi

        if [ $ACOUNT -ne 0 ]; then
            if [ $ABLINK -ne 0 ]; then
                AICON="^fg(#FFFF00)^i($ICONDIR/pacman.xbm)^fg(#)"
                ABLINK=0
            else
                AICON="^i($ICONDIR/pacman.xbm)"
                ABLINK=1
            fi
        else
            AICON="^fg(#FFFF00)^i($ICONDIR/pacman.xbm)^fg(#)"
        fi
        BLINKCOUNTER=0
    fi

    if [ $DISKCOUNTER -ge $DISKIVAL ]; then
        PER1=$(fdiskusage1per)
        PER2=$(fdiskusage2per)
        PDISK1="^fg($ICONCOL1)^i($ICONDIR/diskette.xbm)^fg(#) HD usage /: $PER1"
        PDISK2="/home:$PER2"
        DISKCOUNTER=0
    fi

    if [ $MEMCOUNTER -ge $SYSIVAL ]; then
        PMEM="^fg($ICONCOL1)^i($ICONDIR/mem.xbm)^fg(#)$(fmem)"
        MEMCOUNTER=0
    fi

    if [ $CPUCOUNTER -ge $SYSIVAL ]; then
        PCPU="^fg($ICONCOL1)^i($ICONDIR/cpu.xbm)^fg(#) $(fcpu)%"
        PCPUTEMP="$(fcputemp)"
        CPUCOUNTER=0
    fi

    if [ $WEATHERCOUNTER -ge $WEATHERIVAL ]; then
        PWEATHER=$(fweather)
        WEATHERCOUNTER=0
    fi

    SEP=^fg($ICONCOL1)^i($ICONDIR/ac.xbm)^fg(#)
    print "[$AICON $PPM] [$PCPU $PCPUTEMP] | $PMEM $PDISK1 $PDISK2 | $PWEATHER $PDATE"

    DATECOUNTER=$((DATECOUNTER+1))
    MAILCOUNTER=$((MAILCOUNTER+1))
    PMCOUNTER=$((PMCOUNTER+1))
    DISKCOUNTER=$((DISKCOUNTER+1))
    MEMCOUNTER=$((MEMCOUNTER+1))
    CPUCOUNTER=$((CPUCOUNTER+1))
    WEATHERCOUNTER=$((WEATHERCOUNTER+1))
    BLINKCOUNTER=$((BLINKCOUNTER+1))


    sleep $INTERVAL
done
