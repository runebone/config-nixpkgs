#!/bin/sh

current_variant=$(setxkbmap -query | grep variant | awk '{print $2}')

if [ "$current_variant" = "dvorak," ]; then
    setxkbmap -layout us,ru
else
    setxkbmap -layout us,ru -variant dvorak,
    xmodmap /home/human/.config/home-manager/assets/rpd.xmodmap
fi
