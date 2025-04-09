#!/usr/bin/env bash

notif="$HOME/.config/swaync/icons/gamemode.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"


HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:passes 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    # swww kill 
    swww img "$HOME/.config/swww/.current_wallpaper"
    notify-send -e -u low -i "$notif" "gamemode enabled. All animations off"
    exit
else
    swww-daemon --format xrgb
    swww img "$HOME/.config/swww/.current_wallpaper"
	sleep 0.1
    wal -i "$HOME/.config/swww/.current_wallpaper"
    notify-send -e -u normal -i "$notif" "gamemode disabled. All animations normal"
    exit
fi
hyprctl reload
