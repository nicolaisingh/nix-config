{ config, lib, pkgs, ... }:

let entities = import <entities>;
    current = import <current>;
    configPath = "/home/${current.user.username}/nix";
in {
  # X11 windowing system
  services.xserver = {
    enable = true;

    # Use plasma5 DE
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
