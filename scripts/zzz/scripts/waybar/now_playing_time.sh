#!/bin/bash

# Get current playback position in seconds
current_time=$(playerctl position 2>/dev/null)

# Get total media length in MM:SS or HH:MM:SS format
media_length=$(playerctl metadata --format "{{ duration(mpris:length) }}" 2>/dev/null)

# Check if playerctl is running and media info is available
if [ -z "$current_time" ] || [ -z "$media_length" ]; then
    echo "No media playing"
    exit 0
fi

# Function to convert HH:MM:SS or MM:SS to total seconds
convert_to_seconds() {
    local time_str="$1"
    local IFS=":"
    read -r -a time_parts <<< "$time_str"
    
    if [ ${#time_parts[@]} -eq 3 ]; then
        echo $((time_parts[0] * 3600 + time_parts[1] * 60 + time_parts[2]))
    elif [ ${#time_parts[@]} -eq 2 ]; then
        echo $((time_parts[0] * 60 + time_parts[1]))
    else
        echo "0"
    fi
}

# Convert media_length to seconds
media_length_seconds=$(convert_to_seconds "$media_length")

# Format time in HH:MM:SS
format_time() {
    local total_seconds=$1
    printf "%02d:%02d:%02d" $((total_seconds / 3600)) $((total_seconds % 3600 / 60)) $((total_seconds % 60))
}

# Format current time and total media length
formatted_current_time=$(format_time "${current_time%.*}")
formatted_media_length=$(format_time "$media_length_seconds")

# Display result
echo "$formatted_current_time / $formatted_media_length"
