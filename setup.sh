#!/usr/bin/env bash

ln -sn $(pwd) ~/nix

nixosconfig=~/nix/configuration.nix
hostconfig=~/nix/host-configuration.nix

echo "- System config: $nixosconfig"
echo "- Host config: $hostconfig"

sudo -v -p 'need password for admin privileges: '
sudo nixos-rebuild -I nixos-config=$nixosconfig -I host-config=$hostconfig switch
sudo -k

exit 0
