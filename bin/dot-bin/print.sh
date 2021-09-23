#!/bin/sh

if [ "${1}" = "full" ]
then
    sleep 0.2
    xdotool key XF86Ungrab
    scrot -z -f -e 'mv $f ~/Pictures/Captures'
fi

if [ "${1}" = "window" ]
then
    sleep 0.2
    xdotool key XF86Ungrab
    scrot -z -f -e 'mv $f ~/Pictures/Captures' -u
fi

if [ "${1}" = "crop" ]
then
    sleep 0.2
    xdotool key XF86Ungrab
    scrot -z -f -e 'mv $f ~/Pictures/Captures' -s -l style=dash,width=2
fi
