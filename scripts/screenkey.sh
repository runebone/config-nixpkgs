#!/bin/sh

if [[ ! `pgrep screenkey` ]]; then
    screenkey --geometry 400x800+1515-900 -s small --opacity 0.4
else
    kill $(pgrep screenkey)
fi
