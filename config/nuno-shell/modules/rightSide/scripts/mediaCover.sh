#!/bin/bash

# This script fetches and caches album art for the current song.
# It's designed to be called by EWW and is optimized to minimize
# network and disk I/O.

WIDGET_DIR=$(dirname "$0")
DEFAULT_COVER="$WIDGET_DIR/assets/DEFAULTImage.jpeg"
CACHE_DIR="$HOME/.cache/eww/assets/media-widget"
mkdir -p "$CACHE_DIR"


show_default_cover() {
    echo "$DEFAULT_COVER"
    exit 0
}


COVER_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)
if [[ -z "$COVER_URL" ]]; then
    show_default_cover
fi


if [[ "$COVER_URL" == file://* ]]; then
    
    LOCAL_PATH=$(printf '%b' "${COVER_URL#file://}")
    if [[ -f "$LOCAL_PATH" ]]; then
        echo "$LOCAL_PATH"
        exit 0
    else
        show_default_cover
    fi
fi


URL_HASH=$(echo -n "$COVER_URL" | md5sum | awk '{print $1}')

EXTENSION="${COVER_URL##*.}"
if [[ "$EXTENSION" == "$COVER_URL" ]] || [[ ${#EXTENSION} -gt 5 ]]; then
    EXTENSION="jpg"
fi
CACHED_COVER="$CACHE_DIR/$URL_HASH.$EXTENSION"

if [ ! -f "$CACHED_COVER" ]; then
    curl -s -L --max-time 5 "$COVER_URL" -o "$CACHED_COVER"
    if [[ $? -ne 0 ]] || [[ ! -s "$CACHED_COVER" ]]; then
        rm -f "$CACHED_COVER"
        show_default_cover
    fi
fi

if file "$CACHED_COVER" | grep -qE 'image|jpeg|png|jpg|gif'; then
    echo "$CACHED_COVER"
else
    rm -f "$CACHED_COVER"
    show_default_cover
fi

exit 0
