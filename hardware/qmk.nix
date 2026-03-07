# For QMK keyboard firmware
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qmk
    via
  ];
  services.udev.packages = [ pkgs.via ];
  hardware.keyboard.qmk.enable = true;
}
