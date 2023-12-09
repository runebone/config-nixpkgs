#!/bin/sh

current_variant=$(setxkbmap -query | grep variant | awk '{print $2}')

if [ "$current_variant" = "dvp," ]; then
    setxkbmap -layout us,ru
else
    setxkbmap -layout us,ru -variant dvp,
fi
