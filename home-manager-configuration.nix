{ config, pkgs, ... }:

let
  host = import <host-config>;

  # Load home-manager here instead of using nix-channel
  # To get sha256: nix-prefetch-url --unpack URL
  homeManager = fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
    sha256 = "sha256:1rzgy9qmrvh9l3jrcjv14kva8sj3imzrpm2vmwcfzp40bk9wdfb5";
  };
in
{
  imports = [
    (import "${homeManager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users."${host.username}" = import ./home-manager/home.nix;
  home-manager.users.vmail = import ./home-manager/home-vmail.nix;
}
