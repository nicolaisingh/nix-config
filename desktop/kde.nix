{
  ...
}:
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;

      # Run on Wayland
      defaultSession = "plasma";
      sddm.wayland.enable = true;

      # Run on X11
      # defaultSession = "plasmax11";
      # sddm.wayland.enable = false;
    };
  };
}
