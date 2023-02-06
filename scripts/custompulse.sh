#!/bin/sh

if /nix/store/dg8j7ygdir1rfpla6qdkl5jjh7d2ykd4-pamixer-1.5/bin/pamixer --get-mute > /dev/null; then
    echo "muted"
else
    echo "$(/nix/store/dg8j7ygdir1rfpla6qdkl5jjh7d2ykd4-pamixer-1.5/bin/pamixer --get-volume)%"
fi
