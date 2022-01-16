{ pkgs }:
let current = import <current>;
in with pkgs; [
  xfce.xfwm4 # for xfwm4-workspace-settings
  xfce.xfce4-panel
  xfce.xfce4-battery-plugin
  xfce.xfce4-clipman-plugin
  xfce.xfce4-cpufreq-plugin
  xfce.xfce4-cpugraph-plugin
  xfce.xfce4-datetime-plugin
  xfce.xfce4-dev-tools
  xfce.xfce4-dict
  xfce.xfce4-fsguard-plugin
  xfce.xfce4-mpc-plugin
  xfce.xfce4-namebar-plugin
  xfce.xfce4-netload-plugin
  xfce.xfce4-pulseaudio-plugin
  xfce.xfce4-sensors-plugin
  xfce.xfce4-systemload-plugin
  xfce.xfce4-timer-plugin
  xfce.xfce4-volumed-pulse
  xfce.xfce4-whiskermenu-plugin
  xfce.catfish
  xfce.gigolo

  plano-theme
  stilo-themes
  pavucontrol
]
