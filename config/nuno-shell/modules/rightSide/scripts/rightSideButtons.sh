#!/bin/bash

if [[ "$1" == "--dolphin" ]]; then
	dolphin &

elif [[ "$1" == "--lock" ]]; then
	hyprlock &

elif [[ "$1" == "--hyprshot" ]]; then
	hyprshot -m region &

elif [[ "$1" == "--terminal" ]]; then
	kitty &

elif [[ "$1" == "--audio" ]]; then
    flatpak run com.saivert.pwvucontrol &
fi
