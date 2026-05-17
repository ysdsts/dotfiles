#!/bin/zsh
# Ghostty の background-opacity を 1 と 0.82 で切り替える
CONFIG="$HOME/.config/ghostty/config"

current=$(grep '^background-opacity' "$CONFIG" | awk -F' = ' '{print $2}')

if [[ "$current" == "1" ]]; then
    sed -i '' 's/^background-opacity = 1$/background-opacity = 0.82/' "$CONFIG"
    sed -i '' 's/^background-blur = 0$/background-blur = 20/' "$CONFIG"
else
    sed -i '' 's/^background-opacity = 0\.82$/background-opacity = 1/' "$CONFIG"
    sed -i '' 's/^background-blur = 20$/background-blur = 0/' "$CONFIG"
fi
