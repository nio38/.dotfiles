#!/bin/bash

# Generate current date and time in the format: DDMMYYYY-HHMMSS
timestamp=$(date +"%Y%m%d-%H%M%S")

# Define the file path with the timestamp
file_path="/home/adi/videos/screenrecords/$timestamp.mp4"

# Run wf-recorder with the dynamically generated file name
wf-recorder --audio --file="$file_path" &
notify-send --app-name=Screenrecorder --expire-time=1000 "Screenrecording is in progress"
