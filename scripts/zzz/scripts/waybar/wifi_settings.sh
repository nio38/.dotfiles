#!/usr/bin/env bash

# Temporary files for Wi-Fi scan and menu
SCAN_RESULTS="/tmp/wifi_scan_results"
MENU_ITEMS="/tmp/rofi_menu_items"

# Initialize menu items with placeholders
echo -e "󰖩    Toggle wi-fi\n󰤨    Currently connected\n󰮯    Scan for networks" > "$MENU_ITEMS"

# Function to check Wi-Fi status
wifi_status() {
    nmcli -t -f WIFI g | grep -q "enabled" && echo "enabled" || echo "disabled"
}

# Function to toggle Wi-Fi
toggle_wifi() {
    if [ "$(wifi_status)" = "enabled" ]; then
        nmcli radio wifi off
        notify-send "Wi-Fi" "Wi-Fi has been disabled."
    else
        nmcli radio wifi on
        notify-send "Wi-Fi" "Wi-Fi has been enabled."
    fi
}

# Function to get the current connection
current_connection() {
    nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2
}

# Function to scan Wi-Fi networks
scan_networks() {
    nmcli -t -f SIGNAL,SECURITY,SSID dev wifi list | sort -nr | awk -F: '
    {
        lock=($2 ~ /WPA|WEP/ ? "" : "")
        printf "%s %s (%d%%)\n", lock, $3, $1
    }' > "$SCAN_RESULTS"
}

# Update the menu dynamically
update_menu() {
    wifi_status=$(wifi_status)
    current_wifi=$(current_connection)
    current_wifi=${current_wifi:-"Not Connected"}

    echo -e "󰖩    Toggle wi-fi ($wifi_status)\n󰤨    Currently connected: $current_wifi\n󰮯    Scan for networks" > "$MENU_ITEMS"
}

# Start scanning in the background
rm -f "$SCAN_RESULTS"
scan_networks &

# Update the menu immediately
update_menu &

# Show initial Rofi menu
selected_option=$(cat "$MENU_ITEMS" | rofi -dmenu -i -p "Wi-fi menu: ")

# Process selection
case "$selected_option" in
"󰖩    Toggle wi-fi"*)
    toggle_wifi
    ;;
"󰤨    Currently connected"*)
    current_wifi=$(current_connection)
    notify-send "Wi-Fi" "You are currently connected to \"$current_wifi\"."
    ;;
"󰮯    Scan for networks")
    while [ ! -s "$SCAN_RESULTS" ]; do sleep 0.1; done
    selected_network=$(cat "$SCAN_RESULTS" | rofi -dmenu -i -p "Available networks: ")
    if [ -n "$selected_network" ]; then
        # Extract SSID and determine if it's secured
        ssid=$(echo "$selected_network" | sed -E 's/^[] //; s/ \([0-9]+%\)$//')
        lock=$(echo "$selected_network" | grep -o "")

        if [ "$lock" = "" ]; then
            password=$(rofi -dmenu -p "Enter wi-fi password: ")
            [ -z "$password" ] && notify-send "Wi-Fi" "Connection canceled: No password entered." && exit
            nmcli dev wifi connect "$ssid" password "$password" 802-11-wireless-security.key-mgmt wpa-psk &&
                notify-send "Wi-Fi" "Connected to \"$ssid\"." ||
                notify-send "Wi-Fi" "Failed to connect to \"$ssid\"."
        else
            nmcli dev wifi connect "$ssid" &&
                notify-send "Wi-Fi" "Connected to \"$ssid\"." ||
                notify-send "Wi-Fi" "Failed to connect to \"$ssid\"."
        fi
    fi
    ;;
*)
    exit
    ;;
esac
