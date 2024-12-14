#!/bin/sh

today=$(date +%Y-%m-%d)

nepToday=$(curl 'https://www.hamropatro.com/getMethod.php' --compressed -X POST --data-raw "actionName=dconverter&datefield=2024-12-14&convert_option=eng_to_nep&state=0.4781698699559769" | awk -F "<span>|</span>" '{print $2}' | tr -d '\n')
echo $nepToday
notify-send -u low "Nepali Date:" "$nepToday "
