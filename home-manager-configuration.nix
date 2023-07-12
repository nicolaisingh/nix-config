{ config, pkgs, ... }:

let
  host = import <host-config>;

  # Load home-manager here instead of using nix-channel
  # To get sha256: nix-prefetch-url --unpack URL
  homeManager = fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
    sha256 = "0dfshsgj93ikfkcihf4c5z876h4dwjds998kvgv7sqbfv0z6a4bc";
  };
in {
  imports = [
    (import "${homeManager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users."${host.username}" = import ./home-manager/home.nix;
}
