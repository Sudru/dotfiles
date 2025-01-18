#!/bin/bash

# Use slurp to select a region, grim to capture the screenshot, and save it to a temporary file
screenshot=$(mktemp --suffix=.png)
# grim -g "$(slurp)" "$screenshot"
export XDG_CURRENT_DESKTOP=sway
flameshot gui -r >"$screenshot"
# Run tesseract OCR on the screenshot and store the output in a variable
text=$(tesseract "$screenshot" -)
# Copy the recognized text to the clipboard using cliphist
echo "$text" | wl-copy

# Clean up the temporary screenshot file
rm "$screenshot"
notify-send -u low "OCR:" "Text copied to clipboard" -t 2000
