{ config, lib, pkgs, ... }:

let
  host = import <host-config>;
  configPath = "/home/${host.username}/nix";
in {
  # X11 windowing system
  services.xserver = {
    enable = true;

    # Use plasma5 DE
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
