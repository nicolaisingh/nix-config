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

  xdg.portal.enable = true;
}
