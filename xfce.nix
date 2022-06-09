{ config, lib, pkgs, ... }:

let entities = import <entities>;
    current = import <current>;
    configPath = "/home/${current.user.username}/nix";
in {
  # X11 windowing system
  services.xserver = {
    enable = true;

    # Use XFCE only as a desktop manager
    desktopManager = {
      xfce = {
        enable = true;
        noDesktop = false;
        enableXfwm = false;
      };
    };
  };

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
  environment.systemPackages = pkgs.callPackage ./packages-xfce.nix {};
}
