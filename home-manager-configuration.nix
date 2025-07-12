{ config, pkgs, ... }:

let
  host = import <host-config>;

  # Load home-manager here instead of using nix-channel
  # To get sha256: nix-prefetch-url --unpack URL
  homeManager = fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "sha256:18ddqcn0dv43lbqm39dvff9c4vkb54ygs2rp6vfxamcxhdqka5k9";
  };
in {
  imports = [
    (import "${homeManager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users."${host.username}" = import ./home-manager/home.nix;
  home-manager.users.vmail = import ./home-manager/home-vmail.nix;
}
