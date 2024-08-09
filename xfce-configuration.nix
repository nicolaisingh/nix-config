{ config, lib, pkgs, ... }:

let
  host = import <host-config>;
  configPath = "/home/${host.username}/nix";
in {
  # Use XFCE only as a desktop manager
  services.xserver.desktopManager.xfce = {
    enable = true;
    noDesktop = true;
    enableXfwm = false;
  };

  # See nixos-option `displayManager.session` for possible values
  services.displayManager.defaultSession = "xfce+my-herbstluftwm";

  # Compositor
  services.picom.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # XFCE panel plugins work only when installed in systemPackages
  environment.systemPackages = with pkgs; [
    xfce.xfwm4 # for xfwm4-workspace-settings
    xfce.xfce4-battery-plugin
    xfce.xfce4-clipman-plugin
    xfce.xfce4-datetime-plugin
    xfce.xfce4-dev-tools
    xfce.xfce4-dict
    xfce.xfce4-icon-theme
    xfce.xfce4-netload-plugin
    xfce.xfce4-panel
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-sensors-plugin
    xfce.xfce4-systemload-plugin
    xfce.xfce4-timer-plugin
    xfce.xfce4-xkb-plugin
    xfce.catfish
    xfce.gigolo
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xarchiver

    pavucontrol
    xscreensaver

    arc-theme
    flat-remix-icon-theme
    matcha-gtk-theme
    qogir-theme
    qogir-icon-theme
    tela-icon-theme

    quintom-cursor-theme
    numix-cursor-theme
    bibata-cursors
    vanilla-dmz
  ];
}
