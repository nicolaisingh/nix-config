#!/usr/bin/env bash
# Qogir colors

hc remove_attr theme.my_qogir_highlight
hc remove_attr theme.my_qogir_highlight_dark
hc remove_attr theme.my_normal
hc remove_attr theme.my_normal_accent
hc remove_attr theme.my_normal_accent_2
hc remove_attr theme.my_font
hc remove_attr theme.my_urgent

hc new_attr string theme.my_qogir_highlight '#5294e2'
hc new_attr string theme.my_qogir_highlight_dark '#335c8c'
hc new_attr string theme.my_normal '#f7f7f7'
hc new_attr string theme.my_normal_accent '#d2d2d2'
hc new_attr string theme.my_normal_accent_2 '#b0b0b0'
hc new_attr string theme.my_font '#323232'
hc new_attr string theme.my_urgent '#f0a54c'

hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1

hc set always_show_frame on
hc set frame_border_active_color $(hc attr theme.my_normal_accent_2)
hc set frame_border_normal_color $(hc attr theme.my_normal)
hc set frame_bg_normal_color $(hc attr theme.my_normal)
hc set frame_bg_active_color $(hc attr theme.my_normal)
hc set frame_border_width 1
hc set frame_bg_transparent on
hc set frame_transparent_width 0
hc set frame_gap 0

hc attr theme.title_depth 3
hc attr theme.title_height 13
hc attr theme.title_font "Source Sans Pro:size=9:style=regular"
hc attr theme.title_align center
hc attr theme.title_when one_tab
hc attr theme.active.title_color "#ffffff"
hc attr theme.normal.title_color $(hc attr theme.my_font)

hc attr theme.padding_top 0
hc attr theme.padding_right 0
hc attr theme.padding_bottom 0
hc attr theme.padding_left 0

hc attr theme.border_width 2
hc attr theme.inner_width 1
hc attr theme.outer_width 1

# border colors
hc attr theme.normal.color       $(hc attr theme.my_normal)
hc attr theme.normal.inner_color $(hc attr theme.my_normal_accent)
hc attr theme.normal.outer_color $(hc attr theme.my_normal_accent)
hc attr theme.active.color       $(hc attr theme.my_qogir_highlight)
hc attr theme.active.inner_color $(hc attr theme.my_qogir_highlight)
hc attr theme.active.outer_color $(hc attr theme.my_qogir_highlight)
hc attr theme.urgent.color       $(hc attr theme.my_urgent)
hc attr theme.urgent.inner_color $(hc attr theme.my_urgent)
hc attr theme.urgent.outer_color $(hc attr theme.my_urgent)
hc attr theme.background_color   '#fcfcfc'

# hc attr theme.floating.outer_color '#eff0f1'
# hc attr theme.floating.inner_color '#3daee9'

hc set window_gap 1
hc set frame_padding 0
hc set smart_window_surroundings off
hc set smart_frame_surroundings off
hc set mouse_recenter_gap 0
