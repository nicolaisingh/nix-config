# Enable CUPS to print documents.
# services.printing.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# console.font = "Lat2-Terminus16";

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../desktop/gnome.nix
    # ./desktop/kde.nix TODO: Test
    ../../hardware/qmk.nix
  ];

  fonts = {
    packages = with pkgs; [
      courier-prime
      fantasque-sans-mono
      fira
      hermit
      inconsolata
      intel-one-mono
      libertine
      lmodern
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];
  };

  environment.shellAliases = {
    "nb" = "sudo nixos-rebuild switch --flake ~/src/nixos-config#adonaios";
  };

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "nas";
      };
    };
  };

  system.stateVersion = "25.11";
}
