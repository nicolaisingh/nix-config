#!/usr/bin/env bash
# KDE Breeze colors

hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1

hc set always_show_frame on
# hc set frame_border_active_color '#da4453'
hc set frame_border_active_color '#3b6ba3'
hc set frame_border_normal_color '#7f8c8d'
hc set frame_bg_normal_color '#565656'
hc set frame_bg_active_color '#565656'
hc set frame_border_width 1
hc set frame_bg_transparent on
hc set frame_transparent_width 0
hc set frame_gap 3

hc attr theme.active.title_height 0
hc attr theme.active.title_font "Noto Sans:size=9"
hc attr theme.active.title_color "#ffffff"
hc keybind $Mod-Control-Shift-t cycle_value theme.active.title_height 0 15

hc attr theme.padding_top 0
hc attr theme.padding_right 0
hc attr theme.padding_bottom 0
hc attr theme.padding_left 0

hc attr theme.border_width 4
hc attr theme.inner_width 2
hc attr theme.outer_width 1

# border colors
hc attr theme.normal.color       '#eff0f1'
hc attr theme.normal.inner_color '#475057'
hc attr theme.normal.outer_color '#eff0f1'
hc attr theme.active.color       '#5294e2'
hc attr theme.active.inner_color '#5294e2'
hc attr theme.active.outer_color '#5294e2'
# hc attr theme.active.color       '#ef4b5b'
# hc attr theme.active.inner_color '#ef4b5b'
# hc attr theme.active.outer_color '#ef4b5b'
hc attr theme.urgent.color       '#f67400'
hc attr theme.urgent.inner_color '#f67400'
hc attr theme.urgent.outer_color '#f67400'
hc attr theme.background_color   '#fcfcfc'

# hc attr theme.floating.outer_color '#eff0f1'
# hc attr theme.floating.inner_color '#3daee9'

hc set window_gap 0
hc set frame_padding 0
hc set smart_window_surroundings off
hc set smart_frame_surroundings off
hc set mouse_recenter_gap 0
