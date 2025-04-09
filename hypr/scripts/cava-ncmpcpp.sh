#!/bin/zsh

KITTY_ID=$(kitty @ ls | jq -r '.[0].id')

kitty @ launch --location=vsplit --match=id:$KITTY_ID -- zsh -c 'cava'
kitty @ resize-window -m id:$KITTY_ID -a vertical -i 15

ncmpcpp
