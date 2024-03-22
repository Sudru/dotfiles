#!/bin/bash
copy_full="󰹑 FullScreen Copy "
save_full="󰹑 FullScreen Save "
copy_sel="󰹟 Selection Copy "
save_sel="󰹟 Selection Save "

actions="$copy_full\n$copy_sel\n$save_full\n$save_sel"

selected="$(echo -e "$actions"| wofi -d -p "Eaa Screenshot po lini ?" -i)"

# if no options selected
if test -z "$selected"; then
    exit
fi

case $selected in
        $copy_sel)
			grim -g "$(slurp)" - | wl-copy
			notify-send "Screenshot" "Selection copied to clipboard"
			;;
        $copy_full)
			sleep 0.5; grim - | wl-copy
			notify-send "Screenshot" "Fullscreen copied to clipboard"
			;;
		$save_sel)
			name=/home/$USER/Pictures/screenshot_$(date +%b-%d_%H-%H-%M-%S).png
			grim -g "$(slurp)" "$name"
			notify-send "Screenshot" "Selection saved to $name"
			;;
        $save_full)
			name=/home/$USER/Pictures/screenshot_$(date +%b-%d_%H-%H-%M-%S).png
			sleep 0.5; grim "$name"
			notify-send "Screenshot" "Fullscreen saved to $name"
            ;;
esac
