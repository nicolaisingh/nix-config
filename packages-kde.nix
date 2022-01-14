{ pkgs }:
let current = import <current>;
in with pkgs; [
  ark
  breeze-gtk
  dragon
  k3b
  kate
  kcalc
  kcharselect
  kde-gtk-config
  kdenlive
  kmenuedit
  ktimer
  ktorrent
  okular
]
