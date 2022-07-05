{ pkgs }:
let current = import <current>;
in with pkgs; [
  xfce.xfwm4 # for xfwm4-workspace-settings
  xfce.xfce4panel
  xfce.xfce4-battery-plugin
  xfce.xfce4-clipman-plugin
  xfce.xfce4-datetime-plugin
  xfce.xfce4-dev-tools
  xfce.xfce4-dict
  xfce.xfce4-icon-theme
  xfce.xfce4-namebar-plugin
  xfce.xfce4-netload-plugin
  xfce.xfce4-pulseaudio-plugin
  xfce.xfce4-sensors-plugin
  xfce.xfce4-systemload-plugin
  xfce.xfce4-timer-plugin
  xfce.catfish
  xfce.gigolo
  xfce.thunar
  xfce.thunar-archive-plugin
  xfce.thunar-volman
  xarchiver

  pavucontrol
  xscreensaver

  matcha-gtk-theme
  qogir-theme
  qogir-icon-theme
  tela-icon-theme

  quintom-cursor-theme
  numix-cursor-theme
  bibata-cursors
  vanilla-dmz
]
