#!/usr/bin/env bash
# Toggle between `max' and the frame's previous layout.

hc() {
    herbstclient "$@"
}

# Store the layout, unless the frame is maxed
currlayout=$(hc layout | grep FOCUS | grep -o "horizontal\|vertical\|max\|grid")
[ $currlayout != 'max' ] && hc set_attr tmp.my_max_toggle "$currlayout"

prevlayout=$(hc get_attr tmp.my_max_toggle)
hc cycle_layout +1 "${prevlayout:-horizontal}" max
