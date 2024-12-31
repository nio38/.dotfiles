#!/bin/bash

source ~/zzz/scripts/waybar/utils.sh

# Get the current artist name
artist_name=$(playerctl metadata --format "{{ artist }}" 2>/dev/null)

if [ -z "$artist_name" ]; then
    # No artist information
    printf "生きている"
else
    # Truncate and escape the artist name
    truncated_artist=$(truncate_string "$artist_name")
    escaped_artist=$(escape_markup "$truncated_artist")
    printf "%s\n" "$escaped_artist"
fi
