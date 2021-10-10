#!/usr/bin/env bash
# Toggle moving the current window to the `$max_tag' tag.

hc() {
    herbstclient "$@"
}

max_tag="max"

# If empty string, $max_tag is not focused
full_focused=$(hc tag_status | grep -o "#${max_tag}")

if [ -n "$full_focused" ]; then
    hc and . use_previous \
           . merge_tag $max_tag
else
    hc and . add $max_tag \
           . move $max_tag \
           . use $max_tag
fi
