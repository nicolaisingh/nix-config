#!/bin/sh

configpath=~/nix/configuration.nix
currentconfigpath=~/nix/current.nix

echo "config path: $configpath"
echo "current config path: $currentconfigpath"

ln -sfn "$(pwd)" ~/nix						# nix config

sudo -v -p 'need password for admin privileges: '
sudo nixos-rebuild -I nixos-config=$configpath -I current=$currentconfigpath switch
sudo -k

exit 0
