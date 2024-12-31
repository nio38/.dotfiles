WALL=$(wl-paste)

## pywal
rm -rf ~/.cache/wal/*
wal -i "$WALL"

## waybar
killall -SIGUSR2 waybar

## pywal in applications
pywalfox update &
walogram -s &

## hyprpaper & hyprlock
sed -i "s|^wallpaper =.*|wallpaper = ,$WALL|" ~/.config/hypr/hyprpaper.conf
sed -i "s|^preload =.*|preload = $WALL|" ~/.config/hypr/hyprpaper.conf
sed -i "4s|path = .*|path = $WALL|" ~/.config/hypr/hyprlock.conf
pkill hyprpaper
# hyprpaper &
nohup hyprpaper &> /dev/null &

notify-send --app-name=Wallpaper --expire-time=4000 --icon="$WALL" "Wallpaper" "New wallpaper applied!"

# kill -9 $PPID
