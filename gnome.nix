{ config, lib, pkgs, ...}:

let entities = import <entities>;
    current = import <current>;
    configPath = "/home/${current.user.username}/nix";
in {
  # X11 windowing system
  services.xserver = {
    enable = true;

    # Use GNOME DE
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Conflicts with `services.tlp'
  services.power-profiles-daemon.enable = false;

  environment.gnome.excludePackages = [
    pkgs.gnome.gnome-music
    pkgs.gnome.gnome-characters
  ];
}
