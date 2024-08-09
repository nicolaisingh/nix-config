{ config, lib, pkgs, ... }:

let
  host = import <host-config>;
  configPath = "/home/${host.username}/nix";
in {
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # Run on X11
  services.displayManager.defaultSession = "plasmax11";
  services.displayManager.sddm.wayland.enable = false;
}
