{ config, pkgs, ... }:

let
  host = import <host-config>;

  # Load home-manager here instead of using nix-channel
  # To get sha256: nix-prefetch-url --unpack URL
  homeManager = fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz";
    sha256 = "1fw01zfankc80rna9ch65p7bpg6fwcnvc0pmwvkpfazb7xq92108";
  };
in {
  imports = [
    (import "${homeManager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users."${host.username}" = import ./home-manager/home.nix;
}
