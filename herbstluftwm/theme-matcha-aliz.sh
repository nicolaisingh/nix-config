#!/usr/bin/env bash
# KDE Breeze colors

hc new_attr string theme.my_aliz_red '#f0544c'
hc new_attr string theme.my_aliz_red_50 '#f0a29e'
hc new_attr string theme.my_aliz_red_70 '#f0827d'
hc new_attr string theme.my_aliz_red_dark '#8f322d'
hc new_attr string theme.my_normal '#f7f7f7'
hc new_attr string theme.my_normal_dark '#808080'
hc new_attr string theme.my_normal_accent '#d2d2d2'
hc new_attr string theme.my_font '#323232'
hc new_attr string theme.my_urgent '#f0a54c'

hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1

hc set always_show_frame on
hc set frame_border_active_color $(hc attr theme.my_aliz_red_dark)
hc set frame_border_normal_color $(hc attr theme.my_normal)
hc set frame_bg_normal_color $(hc attr theme.my_normal)
hc set frame_bg_active_color $(hc attr theme.my_normal)
hc set frame_border_width 1
hc set frame_bg_transparent on
hc set frame_transparent_width 0
hc set frame_gap 5

hc attr theme.title_depth 2
hc attr theme.title_height 15
hc attr theme.title_font "TeX Gyre Heros:size=9:style=regular"
hc attr theme.title_align left
hc attr theme.title_when one_tab
hc attr theme.active.title_color "#ffffff"
hc attr theme.normal.title_color $(hc attr theme.my_font)

hc attr theme.padding_top 0
hc attr theme.padding_right 0
hc attr theme.padding_bottom 0
hc attr theme.padding_left 0

hc attr theme.border_width 4
hc attr theme.inner_width 1
hc attr theme.outer_width 1

# border colors
hc attr theme.normal.color       $(hc attr theme.my_normal)
hc attr theme.normal.inner_color $(hc attr theme.my_normal_accent)
hc attr theme.normal.outer_color $(hc attr theme.my_normal_accent)
hc attr theme.active.color       $(hc attr theme.my_aliz_red)
hc attr theme.active.inner_color $(hc attr theme.my_aliz_red_dark)
hc attr theme.active.outer_color $(hc attr theme.my_aliz_red_50)
hc attr theme.urgent.color       $(hc attr theme.my_urgent)
hc attr theme.urgent.inner_color $(hc attr theme.my_urgent)
hc attr theme.urgent.outer_color $(hc attr theme.my_urgent)
hc attr theme.background_color   '#fcfcfc'

# hc attr theme.floating.outer_color '#eff0f1'
# hc attr theme.floating.inner_color '#3daee9'

hc set window_gap 0
hc set frame_padding 0
hc set smart_window_surroundings off
hc set smart_frame_surroundings off
hc set mouse_recenter_gap 0
