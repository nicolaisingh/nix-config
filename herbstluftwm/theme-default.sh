#!/usr/bin/env bash
# Default herbstluftwm colors

hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1
hc set frame_border_active_color '#222222'
hc set frame_border_normal_color '#101010'
hc set frame_bg_normal_color '#565656'
hc set frame_bg_active_color '#345F0C'
hc set frame_border_width 1
hc set always_show_frame on
hc set frame_bg_transparent on
hc set frame_transparent_width 5
hc set frame_gap 4

hc attr theme.active.color '#9fbc00'
hc attr theme.normal.color '#454545'
hc attr theme.urgent.color orange
hc attr theme.inner_width 1
hc attr theme.inner_color black
hc attr theme.border_width 3
hc attr theme.floating.border_width 4
hc attr theme.floating.outer_width 1
hc attr theme.floating.outer_color black
hc attr theme.active.inner_color '#3E4A00'
hc attr theme.active.outer_color '#3E4A00'
hc attr theme.background_color '#141414'

hc set window_gap 0
hc set frame_padding 0
hc set smart_window_surroundings off
hc set smart_frame_surroundings on
hc set mouse_recenter_gap 0
