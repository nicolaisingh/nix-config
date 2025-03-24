{ config, pkgs, ... }:

let
  host = import <host-config>;

  # Load home-manager here instead of using nix-channel
  # To get sha256: nix-prefetch-url --unpack URL
  homeManager = fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
    sha256 = "sha256:156hc11bb6xiypj65q6gzkhw1gw31dwv6dfh6rnv20hgig1sbfld";
  };
in {
  imports = [
    (import "${homeManager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users."${host.username}" = import ./home-manager/home.nix;
  home-manager.users.vmail = import ./home-manager/home-vmail.nix;
}
