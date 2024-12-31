#!/bin/bash

source ~/zzz/scripts/waybar/utils.sh

# Get the current track title
song_name=$(playerctl metadata --format "{{ title }}" 2>/dev/null)

if [ -z "$song_name" ]; then
    # No song playing
    printf "󰎇"
else
    # Truncate and escape the song title
    truncated_title=$(truncate_string "$song_name")
    escaped_title=$(escape_markup "$truncated_title")
    printf "%s\n" "$escaped_title"
fi
