#!/usr/bin/env bash
# Prompt for a new tag name to use for the current tag.

hc() {
    herbstclient "$@"
}

currtag=$(hc attr tags.focus.name)
newtag=$(rofi -dmenu -p "Rename tag ${currtag} to" -l 0)
hc rename "$currtag" "$newtag"
